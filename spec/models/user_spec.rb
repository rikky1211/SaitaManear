require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'バリデーション' do
    context 'emailについて' do
      it 'メールアドレスが必須であること' do
        user.email = nil
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'メールアドレスが一意であること' do
        create(:user, email: 'test@example.com')
        user.email = 'test@example.com'
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("has already been taken")
      end

      it '有効なメールアドレス形式であること' do
        user.email = 'invalid-email'
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    context 'nameについて' do
      it 'ニックネームが必須であること' do
        user.name = nil
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'ニックネームが空文字列の場合無効であること' do
        user.name = ''
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context 'passwordについて' do
      it 'パスワードが必須であること' do
        user.password = nil
        user.password_confirmation = nil
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'パスワードが6文字未満の場合無効であること' do
        user.password = '12345'
        user.password_confirmation = '12345'
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      it 'パスワード確認が一致しない場合無効であること' do
        user.password = 'password'
        user.password_confirmation = 'different'
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end

    context 'uidについて（OAuth）' do
      it 'uidがある場合、providerとの組み合わせで一意であること' do
        create(:user, provider: 'google_oauth2', uid: '123456')
        user.provider = 'google_oauth2'
        user.uid = '123456'
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to include("has already been taken")
      end

      it 'uidがない場合はバリデーションをスキップすること' do
        user.uid = nil
        user.provider = nil
        expect(user).to be_valid
      end
    end

    context '有効なユーザー' do
      it '全ての必須項目が揃っている場合有効であること' do
        expect(user).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it 'spotsを持つこと' do
      association = User.reflect_on_association(:spots)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'favoritesを持つこと' do
      association = User.reflect_on_association(:favorites)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'favorite_to_spotsを持つこと' do
      association = User.reflect_on_association(:favorite_to_spots)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:favorites)
      expect(association.options[:source]).to eq(:spot)
    end
  end

  describe 'enum role' do
    it 'roleが正しく定義されていること' do
      expect(User.roles).to eq({ 'general' => 0, 'admin' => 1, 'super_admin' => 2 })
    end

    it 'デフォルトでgeneralであること' do
      new_user = User.new
      expect(new_user.role).to eq('general')
    end

    it 'adminに設定できること' do
      user.admin!
      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end

    it 'super_adminに設定できること' do
      user.super_admin!
      expect(user.role).to eq('super_admin')
      expect(user.super_admin?).to be_truthy
    end
  end

  describe 'インスタンスメソッド' do
    let(:spot) { create(:spot) }

    describe '#favorite' do
      it 'スポットをお気に入りに追加できること' do
        user.save!
        expect { user.favorite(spot) }.to change { user.favorite_to_spots.count }.by(1)
        expect(user.favorite_to_spots).to include(spot)
      end
    end

    describe '#unfavorite' do
      it 'スポットをお気に入りから削除できること' do
        user.save!
        user.favorite(spot)
        expect { user.unfavorite(spot) }.to change { user.favorite_to_spots.count }.by(-1)
        expect(user.favorite_to_spots).not_to include(spot)
      end
    end

    describe '#favorite?' do
      it 'お気に入りのスポットの場合trueを返すこと' do
        user.save!
        user.favorite(spot)
        expect(user.favorite?(spot)).to be_truthy
      end

      it 'お気に入りでないスポットの場合falseを返すこと' do
        user.save!
        expect(user.favorite?(spot)).to be_falsy
      end
    end

    describe '#own?' do
      it '自分のスポットの場合trueを返すこと' do
        user.save!
        own_spot = create(:spot, user: user)
        expect(user.own?(own_spot)).to be_truthy
      end

      it '他人のスポットの場合falseを返すこと' do
        user.save!
        other_user = create(:user)
        other_spot = create(:spot, user: other_user)
        expect(user.own?(other_spot)).to be_falsy
      end
    end
  end

  describe 'クラスメソッド' do
    describe '.from_omniauth' do
      let(:auth) do
        OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            name: 'Test User',
            email: 'test@google.com'
          }
        })
      end

      it '新しいユーザーを作成すること' do
        expect { User.from_omniauth(auth) }.to change { User.count }.by(1)
      end

      it '既存のユーザーを返すこと' do
        existing_user = create(:user, provider: 'google_oauth2', uid: '123456789')
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end

      it '作成されたユーザーが正しい属性を持つこと' do
        user = User.from_omniauth(auth)
        expect(user.name).to eq('Test User')
        expect(user.email).to eq('test@google.com')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')
        expect(user.password).to be_present
      end
    end

    describe '.create_unique_string' do
      it 'UUIDを生成すること' do
        uuid = User.create_unique_string
        expect(uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
      end

      it '毎回異なる値を生成すること' do
        uuid1 = User.create_unique_string
        uuid2 = User.create_unique_string
        expect(uuid1).not_to eq(uuid2)
      end
    end
  end
end