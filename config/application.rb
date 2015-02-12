require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CollectiveMind
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = "Europe/Moscow"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.locale = config.i18n.locale = config.i18n.default_locale
    I18n.available_locales = config.i18n.available_locales = [:en, :he, :ru]
    # config.i18n.available_locales = ['en_US', 'en_CA', 'en-AU', 'en-GB', 'en-BORK', 'en-IND', :en, :ru, :he]

    config.active_record.default_timezone = :local

    config.generators do |g|
      g.test_framework :rspec
    end
    config.to_prepare do
      Devise::SessionsController.layout 'devise'
      Devise::RegistrationsController.layout 'devise'
      Devise::PasswordsController.layout 'devise'
    end
  end
end
