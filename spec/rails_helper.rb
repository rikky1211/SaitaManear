# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  
  # テストごとにデータベースの変更を巻き戻す（ロールバック）事で
  # DBにデータを残さず、毎回クリーンな状態でテストできる
  config.use_transactional_fixtures = true

  # コメントアウト解除
  # spec ファイルの場所から自動で spec type を判別してくれる機能
  # (RSpec.describe User, type: :model do みたいに[type: :model]とモデル・コントローラの指定不要)
  config.infer_spec_type_from_file_location!

  # RSpecのエラー表示から「Rails内部の処理部分」を省き、テストの失敗原因が自分のコードに関係する部分だけ見やすくなる
  config.filter_rails_from_backtrace!

  # 追加_FactoryBotのメソッドを使えるようにする
  config.include FactoryBot::Syntax::Methods
end
