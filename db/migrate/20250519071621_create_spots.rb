class CreateSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :spots, id: false do |t|
      t.uuid :id, primary_key: true, default: -> { "gen_random_uuid()" }
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.references :town, null: false, foreign_key: true
      t.string :name, null: false
      t.string :spot_image
      t.string :address
      t.text :opening_hours
      t.text :summary
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
