source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'

# ============================================================
# Server
# ===
# Use puma as the app server
gem 'puma'

# ============================================================
# Database
# ===
gem 'pg', '~> 0.18.2'
# Bulk insert. ex   User.import users => makes bulk insert sql
gem 'activerecord-import'
# Create survey
gem 'survey', '~> 0.1'
# for soft deletion
gem 'rails4_acts_as_paranoid'
# Import export csv,excel
gem 'roo'

# ============================================================
# Template processors
# ===
# enable slim format
gem 'slim-rails'

# ============================================================
# Assets processors
# ===
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'lodash-rails', '~> 3.10.1'

# ============================================================
# Tools
# ===
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'restfully', '~> 1.1.1'

# ============================================================
# Helper
# ===
gem 'nokogiri', '~> 1.6.6.2'
gem 'responders', '~> 2.0'

# # ============================================================
# # admin
# # ===
# gem 'rails_admin'

# ============================================================
# Production env
group :production do
    gem 'rails_12factor'
    gem 'rack-timeout', require: 'rack/timeout/base'
end

# ============================================================
# Develop env
group :development do
    gem 'rails-erd'
end
group :development, :test do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'database_cleaner'
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug'
end
