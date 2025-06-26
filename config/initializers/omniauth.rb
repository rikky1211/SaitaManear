Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret]
end
OmniAuth.config.allowed_request_methods = %i[get]
# セキュリティ設定の一環で、GETリクエストのみを許可しています。
# ただし、CSRF攻撃を防ぐために、POSTリクエストを使用する方が一般的です。
# 開発環境では簡便さを重視してGETメソッドを許可していますが、本番環境ではPOSTリクエストを推奨されます。

