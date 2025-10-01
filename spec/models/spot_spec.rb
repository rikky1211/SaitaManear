require 'rails_helper'

RSpec.describe Spot, type: :model do
  let(:spot) { build(:spot) }

  describe 'バリデーション' do
    context 'nameについて' do
      it 'スポット名が必須であること' do
        spot.name = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:name]).to include("can't be blank")
      end

      it 'スポット名が空文字列の場合無効であること' do
        spot.name = ''
        expect(spot).not_to be_valid
        expect(spot.errors[:name]).to include("can't be blank")
      end
    end

    context 'latitudeについて' do
      it '緯度が必須であること' do
        spot.latitude = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:latitude]).to include("can't be blank")
      end
    end

    context 'longitudeについて' do
      it '経度が必須であること' do
        spot.longitude = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:longitude]).to include("can't be blank")
      end
    end

    context 'spot_imageについて' do
      it 'スポット画像が必須であること' do
        spot.spot_image = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:spot_image]).to include("can't be blank")
      end

      it '許可されたファイル形式の場合有効であること' do
        spot.spot_image.attach(
          io: StringIO.new("fake image data"),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
        expect(spot).to be_valid
      end

      it '許可されていないファイル形式の場合無効であること' do
        spot.spot_image.attach(
          io: StringIO.new("fake image data"),
          filename: 'test_file.txt',
          content_type: 'text/plain'
        )
        expect(spot).not_to be_valid
        # 実際のエラーメッセージに修正
        expect(spot.errors[:spot_image]).to include("has an invalid content type (authorized content types are JPG, PNG, GIF, WEBP, HEIC)")
      end

      it 'ファイルサイズが100MB以下の場合有効であること' do
        # 小さなファイル
        spot.spot_image.attach(
          io: StringIO.new("small image data"),
          filename: 'small_image.jpg',
          content_type: 'image/jpeg'
        )
        expect(spot).to be_valid
      end
    end

    context 'userについて' do
      it 'ユーザーが必須であること' do
        spot.user = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:user]).to include("must exist")
      end
    end

    context '埼玉県チェック（must_be_in_saitama）' do
      it '緯度・経度がnilの場合、GoogleMapクリックを促すエラーが出ること' do
        spot.latitude = nil
        spot.longitude = nil
        expect(spot).not_to be_valid
        expect(spot.errors[:base]).to include("GoogleMap上をクリックして、登録するスポット場所を指定してください")
      end

      # 注意: 実際のGeocoder APIを使うテストは時間がかかるため、必要に応じてモック化
      it '埼玉県外の座標の場合無効であること（モックなし版）', :vcr do
        spot.latitude = 35.6762  # 東京駅の座標
        spot.longitude = 139.6503
        expect(spot).not_to be_valid
        expect(spot.errors[:base]).to include("埼玉県以外の場所は登録できません。")
      end
    end

    context '緯度・経度の重複チェック（latlng_uniq）' do
      it '同じ緯度・経度のスポットが既に存在する場合無効であること' do
        existing_spot = create(:spot, latitude: 35.8617, longitude: 139.6455)
        new_spot = build(:spot, latitude: 35.8617, longitude: 139.6455)
        
        expect(new_spot).not_to be_valid
        expect(new_spot.errors[:base]).to include("同じ緯度・経度のスポットはすでに存在します。")
      end

      it '異なる緯度・経度の場合有効であること' do
        existing_spot = create(:spot, latitude: 35.8617, longitude: 139.6455)
        new_spot = build(:spot, latitude: 35.9000, longitude: 139.7000)
        
        expect(new_spot).to be_valid
      end
    end

    context '有効なスポット' do
      it '全ての必須項目が揃っている場合有効であること' do
        expect(spot).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      association = Spot.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'service_tagに属すること（オプショナル）' do
      association = Spot.reflect_on_association(:service_tag)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be_truthy
    end

    it 'spot_season_tagsを持つこと' do
      association = Spot.reflect_on_association(:spot_season_tags)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'season_tagsを持つこと（through spot_season_tags）' do
      association = Spot.reflect_on_association(:season_tags)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:spot_season_tags)
    end

    it 'favoritesを持つこと' do
      association = Spot.reflect_on_association(:favorites)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'Active Storage' do
    it 'spot_imageが添付できること' do
      spot.save!
      expect(spot.spot_image).to be_attached
    end

    it 'spot_imageのファイル名を取得できること' do
      spot.save!
      expect(spot.spot_image.filename.to_s).to eq('test_image.jpg')
    end

    it 'spot_imageのコンテンツタイプを取得できること' do
      spot.save!
      expect(spot.spot_image.content_type).to eq('image/jpeg')
    end
  end

  describe 'コールバック' do
    describe 'before_save :clean_address' do
      it '住所から「日本、〒123-4567 」を削除すること' do
        # addressを直接設定してからclean_addressを呼び出す
        spot.address = "日本、〒330-0001 埼玉県さいたま市浦和区"
        spot.send(:clean_address)  # privateメソッドを直接呼び出し
        expect(spot.address).to eq("埼玉県さいたま市浦和区")
      end

      it '住所に「日本、〒123-4567 」がない場合はそのままにすること' do
        # addressを直接設定してからclean_addressを呼び出す
        spot.address = "埼玉県さいたま市浦和区"
        spot.send(:clean_address)  # privateメソッドを直接呼び出し
        expect(spot.address).to eq("埼玉県さいたま市浦和区")
      end
    end

    describe 'after_validation :reverse_geocode' do
      it '緯度・経度がある場合にreverse_geocodeが実行されること' do
        spot.latitude = 35.8617
        spot.longitude = 139.6455
        expect(spot).to receive(:reverse_geocode)
        spot.valid?
      end

      it '緯度・経度がない場合にreverse_geocodeが実行されないこと' do
        spot.latitude = nil
        spot.longitude = nil
        expect(spot).not_to receive(:reverse_geocode)
        spot.valid?
      end
    end
  end

  describe 'インスタンスメソッド' do
    describe '#latlng_uniq' do
      it '新しいレコードでない場合はチェックしないこと' do
        existing_spot = create(:spot, latitude: 35.8617, longitude: 139.6455)
        existing_spot.name = "更新されたスポット"
        
        expect(existing_spot).to be_valid
      end
    end

    describe '#must_be_in_saitama' do
      it '緯度・経度がnilの場合にエラーメッセージを設定すること' do
        spot.latitude = nil
        spot.longitude = nil
        spot.valid?
        
        expect(spot.errors[:base]).to include("GoogleMap上をクリックして、登録するスポット場所を指定してください")
      end
    end

    describe '#clean_address' do
      it '住所の先頭から日本の郵便番号情報を削除すること' do
        spot.address = "日本、〒330-0001 さいたま市浦和区"
        spot.send(:clean_address)
        
        expect(spot.address).to eq("さいたま市浦和区")
      end
    end
  end

  describe 'ファクトリー' do
    it 'デフォルトファクトリーが有効なスポットを作成すること' do
      expect(spot).to be_valid
    end

    it 'ファクトリーで作成されたスポットが埼玉県内であること' do
      expect(spot.latitude).to be_between(35.7, 36.3)
      expect(spot.longitude).to be_between(138.7, 140.0)
    end

    it 'ファクトリーで画像が正しく添付されること' do
      expect(spot.spot_image).to be_attached
      expect(spot.spot_image.filename.to_s).to eq('test_image.jpg')
      expect(spot.spot_image.content_type).to eq('image/jpeg')
    end
  end

  describe '定数' do
    it 'ACCEPTED_CONTENT_TYPESが正しく定義されていること' do
      expected_types = %w[image/jpeg image/png image/gif image/webp image/heic]
      expect(Spot::ACCEPTED_CONTENT_TYPES).to eq(expected_types)
    end
  end
end