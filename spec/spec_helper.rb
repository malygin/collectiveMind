require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara-screenshot/rspec'
  # require 'simplecov'
  # require 'simplecov-rcov'
  require 'capybara/webkit/matchers'
  require 'database_cleaner'
  #
  # SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  # SimpleCov.start 'rails'

  Capybara.javascript_driver = :webkit

  Capybara.save_and_open_page_path = '/tmp/capybara-screenshot'
  Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
    "screen_#{example.full_description.gsub(' ', '-').gsub(/^.*\/spec\//, '')}"
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
  end
end
