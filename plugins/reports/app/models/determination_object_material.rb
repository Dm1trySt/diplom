class DeterminationObjectMaterial < ActiveRecord::Base
  enum object_type:  { Стекло: 'Стекло',
                       Пластик: 'Пластик',
                       Алюминий: 'Алюминий',
                       Картон: 'Картон',
                       'Не удалось определить': 'Не удалось определить' }

  has_many :determination_object_material_details, :foreign_key => 'determination_object_material_id', class_name: 'DeterminationObjectMaterialDetail'

  validates :object_type, :count, :date, :month, :year, presence: true
end
