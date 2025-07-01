class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.references :spot, null: false, type: :uuid, foreign_key: true
      t.text :summary
      t.timestamps
    end

    add_index :favorites, [ :user_id, :spot_id ], unique: true
  end
end
