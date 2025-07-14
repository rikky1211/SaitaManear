class CreateSpotSeasonTags < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_season_tags do |t|
      t.references :spot, null: false, type: :uuid
      t.references :season_tag, null: false

      t.timestamps
    end

    add_index :spot_season_tags, [:spot_id, :season_tag_id], unique: true
  end
end
