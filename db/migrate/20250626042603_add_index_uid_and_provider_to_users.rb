class AddIndexUidAndProviderToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, [ "uid", "provider" ], name: "index_users_on_uid_and_provider", unique: true
  end
end
