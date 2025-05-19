class CreateTowns < ActiveRecord::Migration[7.2]
  def change
    create_table :towns do |t|
      t.string :short_address, null: false
      
      t.timestamps
    end
  end
end
