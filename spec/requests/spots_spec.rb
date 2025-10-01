require 'rails_helper'

RSpec.describe "Spots", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  # 埼玉県内の座標に修正（さいたま市周辺）
  let(:spot) { create(:spot, user: other_user, latitude: 35.8617, longitude: 139.6455) }

  describe "GET /spots (スポット一覧)" do
    it "GoogleMapが表示されること" do
      get spots_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("map") # GoogleMapの要素があることを確認
    end

    it "正常にページが表示されること" do
      get spots_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /spots/search (スポット検索)" do
    before do
      # 埼玉県内のテスト用スポットを5つ作成
      5.times do |i|
        lat = 35.8617 + (i * 0.001)  # さいたま市周辺から少しずつずらした座標
        lng = 139.6455 + (i * 0.001)
        create(:spot, user: other_user, latitude: lat, longitude: lng, name: "テストスポット#{i + 1}")
      end
    end

    it "GoogleMapが表示されること" do
      get "/spots/search"
      expect(response).to have_http_status(200)
      expect(response.body).to include("map") # GoogleMapの要素があることを確認
    end

    it "スポットの詳細が5つ表示されること" do
      get "/spots/search"
      expect(response).to have_http_status(200)
      
      # 5つのスポットが表示されていることを確認
      (1..5).each do |i|
        expect(response.body).to include("テストスポット#{i}")
      end
    end

    it "正常にページが表示されること" do
      get "/spots/search"
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /spots/new (スポット新規登録)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get new_spot_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "登録画面が表示されること" do
        get new_spot_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("スポット") # 登録フォームがあることを確認
      end

      it "必要なフォームフィールドが表示されること" do
        get new_spot_path
        expect(response).to have_http_status(200)
        
        # 実際のフォームフィールドが存在することを確認
        expect(response.body).to include('name="spot[name]"')
        expect(response.body).to include('name="spot[spot_image]"')
        expect(response.body).to include('name="spot[summary]"')
        expect(response.body).to include('name="spot[latitude]"')
        expect(response.body).to include('name="spot[longitude]"')
      end
    end
  end

  describe "POST /spots (スポット作成)" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post spots_path, params: { spot: { name: "テストスポット" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before { sign_in user }

      context "無効なパラメータの場合" do
        it "埼玉県外の緯度経度では登録できないこと" do
          # 東京都の座標（埼玉県外）
          invalid_params = {
            spot: {
              name: "テストスポット",
              summary: "テスト用の概要",
              latitude: 35.6762, # 東京駅
              longitude: 139.6503,
              address: "東京都千代田区"
            }
          }

          expect {
            post spots_path, params: invalid_params
          }.not_to change(Spot, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("新規スポット登録に失敗しました")
        end

        it "スポット名称なしでは登録できないこと" do
          invalid_params = {
            spot: {
              name: "", # 名前なし
              summary: "テスト用の概要",
              latitude: 35.9000, # 埼玉県内の座標
              longitude: 139.6500,
              address: "埼玉県さいたま市"
            }
          }

          expect {
            post spots_path, params: invalid_params
          }.not_to change(Spot, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          # field_with_errorsクラスの存在で検証エラーを確認
          expect(response.body).to include("field_with_errors")
        end

        it "画像が必須のため画像なしでは登録できないこと" do
          invalid_params = {
            spot: {
              name: "画像なしテスト",
              summary: "画像なしテスト用の概要",
              latitude: 35.9100, # 埼玉県内の座標
              longitude: 139.6600,
              address: "埼玉県さいたま市"
            }
          }

          expect {
            post spots_path, params: invalid_params
          }.not_to change(Spot, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("新規スポット登録に失敗しました")
          expect(response.body).to include("field_with_errors")
        end

        it "同じ緯度経度のスポットは登録できないこと" do
          # 埼玉県内の座標で重複テスト
          test_lat = 35.9200
          test_lng = 139.6700
          
          # 既存のスポットを作成
          create(:spot, user: user, latitude: test_lat, longitude: test_lng)

          duplicate_params = {
            spot: {
              name: "重複テストスポット",
              summary: "重複テスト用の概要",
              latitude: test_lat,   # 既存スポットと同じ座標
              longitude: test_lng,  # 既存スポットと同じ座標
              address: "埼玉県さいたま市"
            }
          }

          expect {
            post spots_path, params: duplicate_params
          }.not_to change(Spot, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("新規スポット登録に失敗しました")
        end
      end
    end
  end

  describe "GET /spots/:id (スポット詳細)" do
    it "スポット詳細ページが表示されること" do
      get spot_path(spot)
      expect(response).to have_http_status(200)
      expect(response.body).to include(spot.name)
    end

    it "存在しないスポットの場合は適切にエラーハンドリングされること" do
      # 実際のアプリでは404エラーをキャッチしている可能性があるため
      get "/spots/999999"
      # ステータスコードで確認（404またはリダイレクト）
      expect([404, 302]).to include(response.status)
    end
  end

  describe "バリデーション確認" do
    before { sign_in user }

    it "名前が空の場合は登録できないこと" do
      invalid_params = {
        spot: {
          name: "",
          summary: "名前なしテスト",
          latitude: 35.9300, # 埼玉県内の座標
          longitude: 139.6800
        }
      }

      expect {
        post spots_path, params: invalid_params
      }.not_to change(Spot, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("field_with_errors")
    end

    it "緯度が空の場合は登録できないこと" do
      invalid_params = {
        spot: {
          name: "緯度なしテスト",
          summary: "緯度なしテスト用",
          longitude: 139.6900 # 埼玉県内の経度
        }
      }

      expect {
        post spots_path, params: invalid_params
      }.not_to change(Spot, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "経度が空の場合は登録できないこと" do
      invalid_params = {
        spot: {
          name: "経度なしテスト",
          summary: "経度なしテスト用",
          latitude: 35.9400 # 埼玉県内の緯度
        }
      }

      expect {
        post spots_path, params: invalid_params
      }.not_to change(Spot, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "セキュリティテスト" do
    it "未認証ユーザーは新規登録ページにアクセスできないこと" do
      get new_spot_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "未認証ユーザーはスポットを作成できないこと" do
      params = {
        spot: {
          name: "未認証テスト",
          latitude: 35.9500, # 埼玉県内の座標
          longitude: 139.7000
        }
      }

      expect {
        post spots_path, params: params
      }.not_to change(Spot, :count)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "UI表示確認" do
    before { sign_in user }

    it "新規登録フォームに画像が必須として表示されること" do
      get new_spot_path
      expect(response).to have_http_status(200)
      
      # 画像フィールドが必須として表示されている
      expect(response.body).to include("*必須")
      expect(response.body).to include("JPEG、PNG、WebP形式")
    end

    it "登録失敗時にエラーメッセージが表示されること" do
      # 無効なデータで登録を試行
      invalid_params = {
        spot: {
          name: "",
          summary: "テスト",
          latitude: 35.9600, # 埼玉県内の座標
          longitude: 139.7100
        }
      }

      post spots_path, params: invalid_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("新規スポット登録に失敗しました")
      expect(response.body).to include("field_with_errors")
    end

    it "バリデーションエラー時にフォームが再表示されること" do
      # 無効なデータで登録を試行
      invalid_params = {
        spot: {
          name: "",
          summary: "テスト",
          latitude: 35.9700, # 埼玉県内の座標
          longitude: 139.7200
        }
      }

      post spots_path, params: invalid_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      # フォームが再表示されている
      expect(response.body).to include('action="/spots"')
      expect(response.body).to include('name="spot[name]"')
      expect(response.body).to include('name="spot[spot_image]"')
    end
  end

  describe "Google Maps表示確認" do
    it "スポット一覧でGoogle Maps APIが読み込まれること" do
      get spots_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("maps.googleapis.com")
    end

    it "スポット検索でGoogle Maps APIが読み込まれること" do
      get "/spots/search"
      expect(response).to have_http_status(200)
      expect(response.body).to include("maps.googleapis.com")
    end

    it "新規登録画面でGoogle Maps APIが読み込まれること" do
      sign_in user
      get new_spot_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("maps.googleapis.com")
      expect(response.body).to include("callback=NewMacker")
    end

    it "新規登録画面にマップ要素が存在すること" do
      sign_in user
      get new_spot_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('id="map"')
      expect(response.body).to include('id="latitude"')
      expect(response.body).to include('id="longitude"')
    end
  end

  describe "フォームフィールド確認" do
    before { sign_in user }

    it "新規登録フォームに正しいフィールド名が設定されていること" do
      get new_spot_path
      expect(response).to have_http_status(200)
      
      # HTMLレスポンスで確認されたフィールド名
      expect(response.body).to include('name="spot[name]"')
      expect(response.body).to include('name="spot[spot_image]"')
      expect(response.body).to include('name="spot[summary]"')
      expect(response.body).to include('name="spot[latitude]"')
      expect(response.body).to include('name="spot[longitude]"')
    end

    it "フォームのenctype属性が正しく設定されていること" do
      get new_spot_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('enctype="multipart/form-data"')
    end
  end

  describe "応答確認" do
    before { sign_in user }

    it "登録失敗時は422ステータスが返されること" do
      invalid_params = {
        spot: {
          name: "",
          latitude: 35.9800, # 埼玉県内の座標
          longitude: 139.7300
        }
      }

      post spots_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "登録失敗時は新規登録画面が再表示されること" do
      invalid_params = {
        spot: {
          name: "",
          latitude: 35.9900, # 埼玉県内の座標
          longitude: 139.7400
        }
      }

      post spots_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("スポット名称")
      expect(response.body).to include("画像")
      expect(response.body).to include("概要")
    end
  end

  describe "統合テスト" do
    before { sign_in user }

    it "スポット作成エラー時の一連の流れが正常に動作すること" do
      # 新規登録ページにアクセス
      get new_spot_path
      expect(response).to have_http_status(200)

      # 無効なデータでスポット作成を試行
      params = {
        spot: {
          name: "", # 名前なしでエラー
          summary: "統合テスト用の概要",
          latitude: 36.0000, # 埼玉県内の座標
          longitude: 139.7500,
          address: "埼玉県朝霞市"
        }
      }

      expect {
        post spots_path, params: params
      }.not_to change(Spot, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("新規スポット登録に失敗しました")
      expect(response.body).to include("field_with_errors")
    end
  end
end