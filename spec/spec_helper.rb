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
    config.infer_spec_type_from_file_location!
    config.profile_examples = 10
    config.order = :random
    Kernel.srand config.seed
    config.include Rails.application.routes.url_helpers
    config.fail_fast = false
    config.include FactoryGirl::Syntax::Methods
    config.include Capybara::DSL
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.order = 'random'
    config.include AbstractController::Translation

    config.before :each, js: true do
      page.driver.block_unknown_urls
      page.driver.allow_url '0.0.0.0'
      page.driver.allow_url 'res.cloudinary.com'
      Capybara.default_wait_time = 5
    end

    config.before :suite do
      DatabaseRewinder.clean_all
    end

    config.after :each do
      DatabaseRewinder.clean
    end
  end
end
