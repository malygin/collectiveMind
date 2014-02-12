require 'rubygems'
require 'spork'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
Spork.prefork do
  RSpec.configure do |config|
    #config.infer_base_class_for_anonymous_controllers = false
    config.use_transactional_fixtures = false
    #config.color_enabled = true
    config.include Capybara::DSL

        config.before(:all) do
      #DatabaseCleaner.strategy = :transaction
      #DatabaseCleaner.clean_with(:truncation)
      #Headless.new(display: 100, reuse: true, destroy_on_exit: false).start
      DatabaseCleaner.start
    end

    config.after(:all) do
      DatabaseCleaner.clean
    end
  end
end
