source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

  # --------- 以下手動追加 --------
  # 1. defaultをコメントアウト/S3導入時にインストール済み
  # gem "image_processing", "~> 1.2"
  # 2. validateのコードを省略して記載できるようにするGem
  gem "active_storage_validations"

  # デバッグGem
  gem "pry-byebug"

  # アプリケーションの文言を英語以外の別の1つの言語に翻訳する機能や、多言語サポート機能を簡単かつ拡張可能な方式で導入するためのフレームワークを提供します。
  gem "rails-i18n", "~> 8.0"

  # WardenをベースにしたRails向けの柔軟な認証ソリューションです。
  gem "devise"

  # Deviseはコントローラー、モデル、その他の領域でi18nをサポートしていますが、
  # 国際化されたビューはサポートしていません。devise-i18nは国際化をサポートします。
  # また、Deviseには実際の翻訳は含まれていません。devise-i18nはこれもサポートします。
  gem "devise-i18n"

  # rubocop Ruby_Lintcheck
  gem "rubocop"

  # GoogleMap APIキー保存/環境変数を管理することができるgemです。(.envファイルで使用)
  gem "dotenv-rails"

  # GoogleMap/住所や地名から座標（経度緯度）を取得したり、その逆を行ったりするgem
  gem "geocoder"

    # ActiveStorage用
    # 1.vips --versionで「libvips」が入ってるか確認。
    #   → brew install vips でインストール
    #   ※画像サイズ加工しない場合はいらないみたい。

    # 2.image_processingをインストール
    gem "image_processing", ">= 1.2"

    # AWSとの通信用
    gem "aws-sdk-s3"

    # tailwindcss用
    # 参考URL https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails
    gem "tailwindcss-ruby"
    gem "tailwindcss-rails"

    # ページネーション
    gem "kaminari"
    gem "kaminari-tailwind"

    # Google認証用(tailwindcssはすでにインストール済み)
    # GoogleのOAuth2を利用した認証を提供するためのGem。ユーザーがGoogleアカウントでサインインできるようにする。
    gem "omniauth-google-oauth2"

    # RailsでOmniAuthを使用する際のCSRF（Cross-Site Request Forgery）攻撃から
    # アプリケーションを保護するためのGem。セキュリティを強化する。
    gem "omniauth-rails_csrf_protection"

# -------- ここまで --------

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
