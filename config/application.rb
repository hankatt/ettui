require_relative "boot"

require "rails/all"
require_relative "../app/middleware/host_redirect"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Well
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.middleware.insert_before 0, HostRedirect

    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: Rails.application.credentials.postmark_api_token }

    # Token to salt remote sign up hashes
    config.remote_sign_up_salt = "Gb8TAeSJrppY3WgGEDzB2Ag8h957mfOmo2Fuk9OdQuM"
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
