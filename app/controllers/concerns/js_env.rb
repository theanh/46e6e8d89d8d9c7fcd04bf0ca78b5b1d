require 'templates_paths'

module JsEnv
  extend ActiveSupport::Concern
  include TemplatesPaths

  included do
    helper_method :js_env
  end

  def js_env
    data = {
        root_url: root_url,
        env: Rails.env,
        templates: templates,
        locale: I18n.locale.to_s,
        locale_sym: I18n.locale.to_s[0, 1],
    }
    <<-EOS.html_safe
      <script type="text/javascript">
        angular.module('AppSurvey').constant('$rails', #{data.to_json});
      </script>
    EOS
  end
end
