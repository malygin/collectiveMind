require 'resque/tasks'
require 'resque_scheduler/tasks'


namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    Resque.redis = 'localhost:6379'
    Resque::Scheduler.dynamic = true
    Resque.schedule = YAML.load_file('config/resque_schedule.yml')
    # Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))
    # require 'jobs'
  end
end


task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
end

task "resque:scheduler_setup" => :environment

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"