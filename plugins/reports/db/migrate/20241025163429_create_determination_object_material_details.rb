class CreateDeterminationObjectMaterialDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :determination_object_material_details, options: 'COLLATE=utf8_general_ci' do |t|
      t.integer :determination_object_material_id, null: false
      t.string :object_name, null: false
      t.string :address, null: false
      t.integer :day, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.timestamps
    end
    
    add_index :determination_object_material_details, :object_name
  end
end
