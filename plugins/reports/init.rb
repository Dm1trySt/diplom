Redmine::Plugin.register :reports do
  name 'Reports'
  author 'D. Storozhev'
  description 'Отчеты'
  version '0.0.1'
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :reports_list
  menu.push :reports_list, {:controller => 'reports_list', :action => 'index'},
            :caption => 'Отчёты', :last => true
end


#ActionDispatch::Callbacks.to_prepare - старый вариант предварительной загрузки классов
Rails.application.config.after_initialize  do

  directory = File.join(__dir__, 'lib', '**', '*.rb')

  files = Dir.glob(directory).sort

  files.each { |file| require_dependency file }
end