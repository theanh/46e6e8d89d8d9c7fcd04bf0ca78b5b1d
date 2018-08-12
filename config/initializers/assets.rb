# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# load extend libs
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
# config.assets.paths += Dir["#{Rails.root}/vendor/asset-libs/*, "].sort_by { |dir| -dir.size }

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( Sortable/component.json, locales/*.json )
