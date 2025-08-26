class CreateServiceTags < ActiveRecord::Migration[8.0]
  def change
    create_table :service_tags do |t|
      t.timestamps
      t.string :name, null: false
      t.references :css_style, null: false
    end
  end
end
