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

      DatabaseCleaner.start
      DatabaseCleaner.clean

      @user = FactoryGirl.create :user
      @project = FactoryGirl.create :core_project, :status => 1
      @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
      @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
      (1..3).each do |i|
        (1..3).each do |j|
          FactoryGirl.create :help_post, stage: i, style: j
        end
        post_mini_1 = FactoryGirl.create :help_post, stage: i, mini: true
        question_mini  = FactoryGirl.create :help_question, post: post_mini_1
        answer_mini = FactoryGirl.create :help_answer, help_question:question_mini
        3.times{ FactoryGirl.create :help_answer, help_question:question_mini }
      end
    end

    config.after(:all) do
      DatabaseCleaner.clean
    end

  end
end
