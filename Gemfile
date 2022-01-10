source 'https://rubygems.org'
ruby '3.0.3'

# Remove 300ms tap event delay for touch devices
gem 'fastclick-rails'
gem 'font-awesome-rails'
gem 'rails', '~> 7.0.0'

# Simplifying HTTP requests
gem 'rest-client'

# CSS Auto prefixer
gem "autoprefixer-rails"

# Email service Postmark
gem 'postmark-rails'
gem 'postmark'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'binding_of_caller'
end

# Support for attr_accessor removed in Rails 4.0.0, this gem adds support. Other gems ease the transition to 4.0.0.
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

# Used for encrypting the users password
gem 'bcrypt'

# App specific Rack gem to handle JSONP callbacks
gem 'rack-jsonp'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.3.0'

gem "jquery-rails"

gem "bootsnap"

gem "msgpack"

gem "webrick"
