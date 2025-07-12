class CreateCssStyles < ActiveRecord::Migration[8.0]
  def change
    create_table :css_styles do |t|
      t.string :style_name, null: false
      t.string :style_color, null: false
      t.string :style_daisyui, null: false
      t.timestamps
    end

    add_index :css_styles, [ :style_name, :style_color, :style_daisyui ], unique: true
  end
end
