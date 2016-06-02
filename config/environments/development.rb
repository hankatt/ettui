Well::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Send email with Postmark
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV["POSTMARK_SMTP_SERVER"],
    port:                 25,
    domain:               'ettui.com',
    user_name:            ENV["POSTMARK_API_TOKEN"],
    password:             ENV["POSTMARK_API_TOKEN"],
    authentication:       :cram_md5,
    enable_starttls_auto: true
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  # config.action_dispatch.best_standards_support = :builtin :: Remove when updating to Rails 4.0.0

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict :: Remove when updating to Rails 4.0.0

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5 :: Remove when updating to Rails 4.0.0

  # Serve static files
  config.serve_static_files = true
  
  # Do not compress assets
  # config.assets.compress = false :: Remove when updating to Rails 4.0.0

  # Expands the lines which load the assets
  config.assets.debug = true

  # Eager load should be false in development environment
  config.eager_load = false

end
