require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment
task "resque:scheduler_setup" => :environment

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    # Resque.redis = 'localhost:6379'
    # ENV['QUEUE'] = '*'
    if ENV['REDISCLOUD_URL']
      uri = URI.parse(ENV['REDISCLOUD_URL'])
      Resque.redis = {host: uri.host, port: uri.port, user: uri.user, password: uri.password}
    else
      Resque.redis = {host: 'localhost', port: '6379'}
    end
    Resque::Scheduler.dynamic = true
    # Resque.schedule = YAML.load_file('config/resque_schedule.yml')
    # Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
    # require 'jobs'
  end
end


# task "resque:setup" => :environment do
#   ENV['QUEUE'] = '*'
# end
#
# task "resque:scheduler_setup" => :environment

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"