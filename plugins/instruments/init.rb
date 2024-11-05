Rails.configuration.instruments = {}
outer_services_file = File.join(File.dirname(__FILE__), 'config', 'outer_services.yml')
if File.file?(outer_services_file)
  Rails.configuration.instruments = HashWithIndifferentAccess.new(YAML::load_file(outer_services_file))
end

Redmine::Plugin.register :instruments do
  name 'Instruments'
  author 'D. Storozhev'
  description 'Полезные инструмены'
  version '0.0.1'


end