get 'reports', to: 'reports_list#index'

scope module: 'common' do
  get 'reports/common/determination_object_material', to: 'determination_object_material#index', as: 'determination_object_material_report'
  match 'reports/common/determination_object_material/get_data.:format', to: 'determination_object_material#get_xlsx_data', via: %i[get post]
  get 'reports/common/determination_object_material/get_data', to: 'determination_object_material#get_data'

end