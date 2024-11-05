class DeterminationObjectMaterialDetail < ActiveRecord::Base

  belongs_to :determination_object_material, :foreign_key => 'determination_object_material_id', class_name: 'DeterminationObjectMaterial'

  validates :determination_object_material_id, :object_name, :address, :day, :month, :year, presence: true
end
