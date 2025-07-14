class CreateSeasonTags < ActiveRecord::Migration[8.0]
  def change
    create_table :season_tags do |t|
      t.string :season, null: false
      t.references :css_style, null: false
      
      t.timestamps
    end
  end
end
