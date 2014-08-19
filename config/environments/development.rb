CollectiveMind::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
          :bucket => 'stuff_bucket',
          :access_key_id => 'AKIAIUXUHQCN45FUQ2UQ',
          :secret_access_key => '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'
      }
  }

  config.action_mailer.raise_delivery_errors = false

  # Expands the lines which load the assets
  config.assets.debug = true
  config.quiet_assets = true
  ::ActiveSupport::Deprecation.silenced = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default :charset => 'utf-8'
  #ActionMailer::Base.smtp_settings = {
  #    :address              => 'smtp.gmail.com',
  #    :port                 => 587,
  #    :user_name            => 'massdecision@gmail.com',
  #    :password             => '11nekotyan',
  #    :authentication       => 'plain',
  #    :enable_starttls_auto => true
  #}
  ActionMailer::Base.smtp_settings = {
      :address              => 'smtp.yandex.com',
      :port                 => 25,
      :user_name            => 'mass-decision',
      :password             => '11nekotyan',
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }
  # Date::DATE_FORMATS[:default]="%-d %b %Y"
  # Time::DATE_FORMATS[:default]="%Y/%m/%d %H:%M"
end
