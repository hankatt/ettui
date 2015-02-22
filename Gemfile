source 'https://rubygems.org'
require 'rubygems'

# Remove 300ms tap event delay for touch devices
gem 'fastclick-rails'

# Icon font
gem 'evil_icons'

# Ruby version
ruby '2.1.4'

gem 'rails', '4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

# Support for attr_accessor removed in Rails 4.0.0, this gem adds support. Other gems ease the transition to 4.0.0.
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

# Used for encrypting the users password
gem 'bcrypt-ruby', :require => "bcrypt"

# App specific Rack gem to handle JSONP callbacks
gem 'rack-jsonp'

# To handle Twitter authentication
gem 'omniauth-twitter'

# To handle Twitter correspondence
gem 'twitter', "~> 4.8" 

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem "jquery-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
