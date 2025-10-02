require 'rails_helper'

RSpec.describe "1ページのみの表示", type: :request do
  describe "Topコントローラー" do
    it "Topページ" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "利用規約" do
      get terms_of_use_path
      expect(response).to have_http_status(200)
    end

    it "プライベートポリシー" do
      get privacy_policy_path
      expect(response).to have_http_status(200)
    end

    it "お問い合わせフォーム" do
      get contact_form_path
      expect(response).to have_http_status(200)
    end
    
    it "Sorryページ" do
      get sorry_path
      expect(response).to have_http_status(200)
    end
  end
end
