require 'rubygems'
require 'spork'
 
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
 
require 'rspec/rails'
require 'rspec/autorun'
#require 'shoulda/matchers'
 
 
Spork.prefork do
  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.include(SessionsHelper, :type => :controller)
    config.infer_base_class_for_anonymous_controllers = false
    config.include Capybara::DSL
  end
end
 
Spork.each_run do
  CollectiveMind::Application.reload_routes!
end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end