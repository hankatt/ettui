source 'https://rubygems.org'
ruby '2.1.4'

# Remove 300ms tap event delay for touch devices
gem 'fastclick-rails'
gem "font-awesome-rails"
gem 'rails', '4.0.0'

# CSS Auto prefixer
gem "autoprefixer-rails"

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
  gem 'sass-rails',   '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
end

gem "jquery-rails", '~> 3.1.3'
