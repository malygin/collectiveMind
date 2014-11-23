require 'resque/status_server'
require 'resque_scheduler'
require 'resque_scheduler/server'

Resque.redis = "localhost:6379"
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
Resque.logger.formatter = Resque::VeryVerboseFormatter.new
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
# Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
# Resque.schedule = YAML.load_file('your_resque_schedule.yml')
Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))