class CreateDeterminationObjectMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :determination_object_materials, options: 'COLLATE=utf8_general_ci' do |t|
      t.string :object_type, null: false
      t.integer :count, default: 1, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.date :date , null: false
      t.timestamps
    end

    add_index :determination_object_materials, :object_type
  end
end
