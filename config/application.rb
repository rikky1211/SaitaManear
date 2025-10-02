require_relative "boot"
require "devise"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # 追加(valiant作成時の処理で使うvariantプロセッサの設定をvipsにする)
    config.active_storage.variant_processor = :vips

    # 追加_[g model モデル名]を売ったときに
    config.generators do |g|
      g.test_framework :rspec   # RSpec/テスト用ファイルを作成
      g.fixture_replacement :factory_bot, dir: "spec/factories" # RSpec/factory_bot用ファイルを作成
    end

    # Rails 8.1 から to_time の挙動がタイムゾーン情報を保持するように変わる
    config.active_support.to_time_preserves_timezone = :zone

    # rails-i18n
    config.i18n.default_locale = :ja
  end
end
