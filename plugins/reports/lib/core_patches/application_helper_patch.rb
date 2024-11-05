module Reports
  module ApplicationHelperPatch
    extend ActiveSupport::Concern


    # Подключение разных версий ангуляра. Для каждой версии в папке +plugins/reports/assets/javascripts+ должна быть
    # папка с название версии например +angular-1.6.5+
    # => angular_include_tag '1.6.5'
    # => angular_include_tag '1.6.5', %w(resource)
    # => angular_include_tag '1.6.5', %w(resource route)
    def angular_include_tag(version, modules = [])
      path = "angular-#{version}"
      sources = ['angular', 'loader', 'i18n/angular-locale_ru-ru.js'] + modules
      sources.map do |source|
        prefix = source =~ /angular/ ? '' : 'angular-'
        postfix = source.ends_with?('.js') ? '' : '.min.js'
        javascript_include_tag "#{path}/#{prefix}#{source}#{postfix}", plugin: 'reports'
      end.join("\n").html_safe
    end
  end
end

if ApplicationHelper.included_modules.exclude? Reports::ApplicationHelperPatch
  ApplicationHelper.send :include, Reports::ApplicationHelperPatch
end
