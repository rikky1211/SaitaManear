require 'rails_helper'

RSpec.describe "Spots", type: :request do
  include Devise::Test::IntegrationHelpers

  # 埼玉県内の有効な座標を使用（各スポットに異なる座標）
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:spot) { create(:spot, user: user, latitude: 35.8617, longitude: 139.6455) }  # さいたま市
  let(:other_spot) { create(:spot, user: other_user, latitude: 36.0956, longitude: 139.3708) }  # 熊谷市
  let(:super_admin) { create(:user, role: 2) }

  # 埼玉県内の座標リスト（確実に埼玉県内の座標のみ）
  def saitama_coordinates
    [
      { latitude: 35.8617, longitude: 139.6455 }, # さいたま市
      { latitude: 36.0956, longitude: 139.3708 }, # 熊谷市
      { latitude: 35.8084, longitude: 139.7243 }, # 川口市
      { latitude: 35.9446, longitude: 139.6850 }, # 上尾市
      { latitude: 35.9911, longitude: 139.6937 }, # 桶川市
      { latitude: 35.8565, longitude: 139.5685 }, # 朝霞市
      { latitude: 35.8288, longitude: 139.5540 }, # 和光市
      { latitude: 35.7756, longitude: 139.6389 }, # 蕨市
      { latitude: 35.8010, longitude: 139.6563 }, # 浦和区
      { latitude: 35.8618, longitude: 139.7012 }, # 見沼区
    ]
  end

  # YourSpotsControllerのテスト（修正版）
  describe "GET /your_spots (自分のスポット一覧)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get "/your_spots"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "自分のスポット一覧が表示されること" do
        # 異なる座標を使用
        coords = saitama_coordinates.first(3)
        coords.each_with_index do |coord, index|
          create(:spot, user: user, latitude: coord[:latitude], longitude: coord[:longitude])
        end
        
        get "/your_spots"
        expect(response).to have_http_status(200)
      end

      it "自分のスポットのみが表示されること" do
        my_spot = create(:spot, user: user, name: "My Spot", latitude: 35.8617, longitude: 139.6455)
        others_spot = create(:spot, user: other_user, name: "Others Spot", latitude: 36.0956, longitude: 139.3708)
        
        get "/your_spots"
        expect(response).to have_http_status(200)
        expect(response.body).to include("My Spot")
        expect(response.body).not_to include("Others Spot")
      end

      it "スポットが0件の場合も正常に表示されること" do
        user.spots.destroy_all
        get "/your_spots"
        expect(response).to have_http_status(200)
        expect(response.body).to include("スポット")
      end
    end
  end

  describe "GET /your_spots/:id/edit (自分のスポット編集)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get "/your_spots/#{spot.id}/edit"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "自分のスポット編集ページが表示されること" do
        get "/your_spots/#{spot.id}/edit"
        expect(response).to have_http_status(200)
      end

      it "他人のスポットは編集できないこと" do
        get "/your_spots/#{other_spot.id}/edit"
        expect(response).to redirect_to(your_spots_path)
        expect(flash[:alert]).to eq("編集権限がないか、スポットが見つかりません")
      end

      it "存在しないスポットの場合はリダイレクトされること" do
        get "/your_spots/999999/edit"
        expect(response).to redirect_to(your_spots_path)
        expect(flash[:alert]).to eq("編集権限がないか、スポットが見つかりません")
      end
    end
  end

  describe "PATCH /your_spots/:id (自分のスポット更新)" do
    let(:update_attributes) do
      {
        name: "更新されたスポット名",
        summary: "更新された概要"
      }
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        patch "/your_spots/#{spot.id}", params: { spot: update_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      context "有効なパラメータの場合" do
        it "スポットが更新されること" do
          patch "/your_spots/#{spot.id}", params: { spot: update_attributes }
          spot.reload
          expect(spot.name).to eq("更新されたスポット名")
        end

        it "スポット詳細ページにリダイレクトされること" do
          patch "/your_spots/#{spot.id}", params: { spot: update_attributes }
          expect(response).to redirect_to(spot_path(spot))
        end
      end

      context "無効なパラメータの場合" do
        let(:invalid_attributes) { { name: "" } }

        it "スポットが更新されないこと" do
          original_name = spot.name
          patch "/your_spots/#{spot.id}", params: { spot: invalid_attributes }
          spot.reload
          expect(spot.name).to eq(original_name)
        end

        it "編集ページが再表示されること" do
          patch "/your_spots/#{spot.id}", params: { spot: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "他人のスポットの場合" do
        it "更新できないこと" do
          patch "/your_spots/#{other_spot.id}", params: { spot: update_attributes }
          expect(response).to redirect_to(your_spots_path)
          expect(flash[:alert]).to eq("更新権限がないか、スポットが見つかりません")
        end
      end
    end
  end

  describe "DELETE /your_spots/:id (自分のスポット削除)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        delete "/your_spots/#{spot.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      context "自分のスポットの場合" do
        it "スポットが削除されること" do
          spot_to_delete = create(:spot, user: user, latitude: 35.8084, longitude: 139.7243)
          expect {
            delete "/your_spots/#{spot_to_delete.id}"
          }.to change(Spot, :count).by(-1)
        end

        it "自分のスポット一覧ページにリダイレクトされること" do
          delete "/your_spots/#{spot.id}"
          expect(response).to redirect_to(your_spots_path)
        end
      end

      context "他人のスポットの場合" do
        it "削除できないこと" do
          delete "/your_spots/#{other_spot.id}"
          expect(response).to redirect_to(your_spots_path)
          expect(flash[:alert]).to eq("削除権限がないか、スポットが見つかりません")
        end
      end

      context "存在しないスポットの場合" do
        it "リダイレクトされること" do
          delete "/your_spots/999999"
          expect(response).to redirect_to(your_spots_path)
          expect(flash[:alert]).to eq("削除権限がないか、スポットが見つかりません")
        end
      end
    end
  end

  describe "GET /your_spots/favorites (お気に入りスポット)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get "/your_spots/favorites"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "お気に入りスポット一覧が表示されること" do
        create(:spot, latitude: 35.9446, longitude: 139.6850)
        get "/your_spots/favorites"
        expect(response).to have_http_status(200)
      end

      it "ページネーションが動作すること" do
        create(:spot, latitude: 35.9446, longitude: 139.6850)
        get "/your_spots/favorites", params: { page: 2 }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "画像アップロード機能" do
    before { sign_in user }

    it "画像なしでスポットを更新できること" do
      patch "/your_spots/#{spot.id}", params: { 
        spot: { 
          name: "画像なし更新"
        } 
      }
      spot.reload
      expect(spot.name).to eq("画像なし更新")
    end

    it "スポットの名前を更新できること" do
      spot_for_update = create(:spot, user: user, name: "元の名前", latitude: 35.9911, longitude: 139.6937)
      
      patch "/your_spots/#{spot_for_update.id}", params: { 
        spot: { 
          name: "更新後の名前"
        } 
      }
      
      spot_for_update.reload
      expect(spot_for_update.name).to eq("更新後の名前")
    end
  end

  describe "エラーハンドリング" do
    before { sign_in user }

    it "存在しないスポットにアクセスした場合の処理" do
      get "/your_spots/999999/edit"
      expect(response).to redirect_to(your_spots_path)
      expect(flash[:alert]).to eq("編集権限がないか、スポットが見つかりません")
    end

    it "権限のないスポットにアクセスした場合の処理" do
      patch "/your_spots/#{other_spot.id}", params: { spot: { name: "Unauthorized" } }
      expect(response).to redirect_to(your_spots_path)
      expect(flash[:alert]).to eq("更新権限がないか、スポットが見つかりません")
    end

    it "バリデーションエラー時の処理" do
      patch "/your_spots/#{spot.id}", params: { 
        spot: { 
          name: ""
        } 
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "セキュリティテスト" do
    before { sign_in user }

    it "他人のスポットを操作できないこと" do
      patch "/your_spots/#{other_spot.id}", params: { spot: { name: "Hacked" } }
      expect(response).to redirect_to(your_spots_path)
      expect(flash[:alert]).to eq("更新権限がないか、スポットが見つかりません")
    end

    it "不正なIDでのアクセスを防げること" do
      get "/your_spots/abc123/edit"
      expect(response).to redirect_to(your_spots_path)
      expect(flash[:alert]).to eq("編集権限がないか、スポットが見つかりません")
    end
  end

  describe "統合テスト" do
    before { sign_in user }

    it "スポット編集から更新までの一連の流れが正常に動作すること" do
      get "/your_spots/#{spot.id}/edit"
      expect(response).to have_http_status(200)
      
      patch "/your_spots/#{spot.id}", params: { 
        spot: { 
          name: "統合テストスポット",
          summary: "統合テスト用の概要"
        } 
      }
      
      expect(response).to redirect_to(spot_path(spot))
      
      spot.reload
      expect(spot.name).to eq("統合テストスポット")
    end

    # 修正：確実に埼玉県内の座標を使用
    it "スポット削除の一連の流れが正常に動作すること" do
      spot_to_delete = create(:spot, user: user, latitude: 35.8010, longitude: 139.6563)  # 浦和区
      spot_id = spot_to_delete.id
      
      delete "/your_spots/#{spot_id}"
      expect(response).to redirect_to(your_spots_path)
      expect(Spot.find_by(id: spot_id)).to be_nil
    end
  end

  describe "データ整合性" do
    before { sign_in user }

    it "スポット更新時にuser_idが変更されないこと" do
      original_user_id = spot.user_id
      
      patch "/your_spots/#{spot.id}", params: { 
        spot: { 
          name: "更新テスト",
          user_id: other_user.id
        } 
      }
      
      spot.reload
      expect(spot.user_id).to eq(original_user_id)
      expect(spot.user_id).not_to eq(other_user.id)
    end

    it "削除時にスポットが確実に削除されること" do
      spot_for_deletion = create(:spot, user: user, latitude: 35.8565, longitude: 139.5685)
      
      delete "/your_spots/#{spot_for_deletion.id}"
      expect(Spot.find_by(id: spot_for_deletion.id)).to be_nil
    end
  end

  # パフォーマンステスト（修正版：座標を動的生成）
  describe "パフォーマンス" do
    before { sign_in user }

    it "大量のスポットがある場合でもページが正常に表示されること" do
      # 50個の異なる座標を生成（埼玉県内の範囲内で）
      50.times do |i|
        # さいたま市周辺で微妙に座標をずらす
        lat = 35.8617 + (i * 0.001)  # 0.001度ずつずらす
        lng = 139.6455 + (i * 0.001)
        create(:spot, user: user, latitude: lat, longitude: lng)
      end
      
      get "/your_spots"
      expect(response).to have_http_status(200)
    end

    it "ページネーション機能が動作すること" do
      # 30個の異なる座標を生成
      30.times do |i|
        lat = 35.8617 + (i * 0.002)  # より大きくずらす
        lng = 139.6455 + (i * 0.002)
        create(:spot, user: user, latitude: lat, longitude: lng)
      end
      
      get "/your_spots", params: { page: 1 }
      expect(response).to have_http_status(200)
      
      get "/your_spots", params: { page: 2 }
      expect(response).to have_http_status(200)
    end
  end

  describe "基本機能確認" do
    before { sign_in user }

    # 修正：確実に埼玉県内の座標を使用
    it "自分のスポット一覧で適切な情報が表示されること" do
      test_spot = create(:spot, user: user, name: "表示テストスポット", latitude: 35.8618, longitude: 139.7012)  # 見沼区
      
      get "/your_spots"
      expect(response).to have_http_status(200)
      expect(response.body).to include("表示テストスポット")
    end

    it "編集ページで既存のスポット情報が表示されること" do
      get "/your_spots/#{spot.id}/edit"
      expect(response).to have_http_status(200)
      expect(response.body).to include(spot.name)
    end

    it "更新後に正しい値が保存されること" do
      new_name = "新しいスポット名"
      patch "/your_spots/#{spot.id}", params: { 
        spot: { name: new_name } 
      }
      
      spot.reload
      expect(spot.name).to eq(new_name)
    end
  end
end