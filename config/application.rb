require File.expand_path('../boot', __FILE__)
require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppSurvey
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Asia/Bangkok'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = true
    config.i18n.available_locales = [:en]
    config.i18n.default_locale = :en

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.exceptions_app = self.routes

    # customization on the generating workflow 
    config.generators do |g|
      g.orm                 :active_record
      g.template_engine     :slim
      
      g.no_migration        true
      g.scaffold_controller false
      g.jbuilder            false
      g.resource_route      false
      g.helper              false
      g.assets              false
    end
  end
end
