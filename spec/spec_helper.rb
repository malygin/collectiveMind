require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara-screenshot/rspec'
  require 'capybara/webkit/matchers'
  require 'database_cleaner'
  require 'websocket_rails/spec_helpers'

  require 'simplecov'
  SimpleCov.start

  Capybara.javascript_driver = :webkit

  Capybara.save_and_open_page_path = 'tmp/capybara-screenshot'

  Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
    "#{example.full_description.gsub(' ', '-').gsub(/^.*\/spec\//, '')}"
  end

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  ActiveRecord::Migration.maintain_test_schema!

  RSpec.configure do |config|
    #config.infer_spec_type_from_file_location!
    config.include Rails.application.routes.url_helpers
    config.fail_fast = false
    config.include FactoryGirl::Syntax::Methods
    config.include Capybara::DSL
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.order = 'random'

    config.before :each, js: true do
      page.driver.block_unknown_urls
      page.driver.allow_url '0.0.0.0'
      page.driver.allow_url 'res.cloudinary.com'
    end
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end
end
