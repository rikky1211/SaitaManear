require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let(:favorite) { Favorite.new(user: user, spot: spot) }

  describe 'バリデーション' do
    context 'userについて' do
      it 'ユーザーが必須であること' do
        favorite.user = nil
        expect(favorite).not_to be_valid
        expect(favorite.errors[:user]).to include("must exist")
      end
    end

    context 'spotについて' do
      it 'スポットが必須であること' do
        favorite.spot = nil
        expect(favorite).not_to be_valid
        expect(favorite.errors[:spot]).to include("must exist")
      end
    end

    context 'ユニーク制約' do
      it '同じユーザーが同じスポットを重複してお気に入りできないこと' do
        # 最初のお気に入りを作成
        Favorite.create!(user: user, spot: spot)
        
        # 同じ組み合わせでもう一度作成を試す
        duplicate_favorite = Favorite.new(user: user, spot: spot)
        expect(duplicate_favorite).not_to be_valid
        expect(duplicate_favorite.errors[:user_id]).to include("has already been taken")
      end

      it '異なるユーザーが同じスポットをお気に入りできること' do
        other_user = create(:user)
        
        Favorite.create!(user: user, spot: spot)
        other_favorite = Favorite.new(user: other_user, spot: spot)
        
        expect(other_favorite).to be_valid
      end

      it '同じユーザーが異なるスポットをお気に入りできること' do
        other_spot = create(:spot)
        
        Favorite.create!(user: user, spot: spot)
        other_favorite = Favorite.new(user: user, spot: other_spot)
        
        expect(other_favorite).to be_valid
      end
    end

    context '有効なお気に入り' do
      it '全ての必須項目が揃っている場合有効であること' do
        expect(favorite).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      association = Favorite.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'spotに属すること' do
      association = Favorite.reflect_on_association(:spot)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'データベースのインデックス' do
    it 'user_idとspot_idの複合ユニークインデックスが機能すること' do
      # 最初のレコードは正常に作成される
      favorite.save!
      
      # 同じuser_id, spot_idの組み合わせは作成できない
      expect {
        Favorite.create!(user: user, spot: spot)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'お気に入り機能の統合テスト' do
    it 'ユーザーがスポットをお気に入りに追加できること' do
      expect {
        user.favorite(spot)
      }.to change { Favorite.count }.by(1)
      
      expect(user.favorite_to_spots).to include(spot)
      expect(user.favorite?(spot)).to be_truthy
    end

    it 'ユーザーがお気に入りを削除できること' do
      user.favorite(spot)
      
      expect {
        user.unfavorite(spot)
      }.to change { Favorite.count }.by(-1)
      
      expect(user.favorite_to_spots).not_to include(spot)
      expect(user.favorite?(spot)).to be_falsy
    end
  end

  describe 'スコープやクラスメソッド（存在する場合）' do
    it 'by_userスコープが存在するかテスト' do
      if Favorite.respond_to?(:by_user)
        favorite.save!
        expect(Favorite.by_user(user)).to include(favorite)
      else
        skip 'by_userスコープが定義されていません'
      end
    end

    it 'by_spotスコープが存在するかテスト' do
      if Favorite.respond_to?(:by_spot)
        favorite.save!
        expect(Favorite.by_spot(spot)).to include(favorite)
      else
        skip 'by_spotスコープが定義されていません'
      end
    end
  end

  describe 'タイムスタンプ' do
    it 'お気に入り作成時にcreated_atが設定されること' do
      favorite.save!
      expect(favorite.created_at).to be_present
    end

    it 'お気に入り更新時にupdated_atが更新されること' do
      favorite.save!
      original_updated_at = favorite.updated_at
      
      sleep(1)
      favorite.touch
      
      expect(favorite.updated_at).to be > original_updated_at
    end
  end
end