require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment
task "resque:scheduler_setup" => :environment
task "resque:work"
desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

# Start a worker with proper env vars and output redirection
def run_worker(queue, count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
  ops = {:pgroup => true, :err => [(Rails.root + "log/resque_err").to_s, "a"],
         :out => [(Rails.root + "log/resque_stdout").to_s, "a"]}
  env_vars = {"QUEUE" => queue.to_s}
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, "rake resque:work", ops)
    Process.detach(pid)
  }
end

namespace :resque do
  task :setup => :environment

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
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
  end

  desc "Restart running workers"
  task :restart_workers => :environment do
    Rake::Task['resque:stop_workers'].invoke
    Rake::Task['resque:start_workers'].invoke
  end

  desc "Quit running workers"
  task :stop_workers => :environment do
    pids = Array.new
    Resque.workers.each do |worker|
      pids.concat(worker.worker_pids)
    end
    if pids.empty?
      puts "No workers to kill"
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "Running syscmd: #{syscmd}"
      system(syscmd)
    end
  end


  desc "Start workers"
  task :start_workers => :environment do
    run_worker("*", 1)
    # run_worker("high", 1)
  end

  task :pause => :environment do
    Resque.redis.set "resque_paused", true
    puts "Resque paused."
  end

  task :resume => :environment do
    Resque.redis.set "resque_paused", false
    puts "Resque resumed."
  end

  task :paused => :environment do
    paused = Resque.redis.get("resque_paused") == 'true'
    puts "Resque paused: #{paused}"
  end
end




# require 'resque/tasks'
#
# task "resque:setup" => :environment
# task "resque:work"
#
# namespace :resque do
#   task :setup => :environment
#
#   desc "Restart running workers"
#   task :restart_workers => :environment do
#     Rake::Task['resque:stop_workers'].invoke
#     Rake::Task['resque:start_workers'].invoke
#   end
#
#   desc "Quit running workers"
#   task :stop_workers => :environment do
#     stop_workers
#   end
#
#   desc "Start workers"
#   task :start_workers => :environment do
#     run_worker("*", 1)
#   end
#
#
#
#   def store_pids(pids, mode)
#     pids_to_store = pids
#     pids_to_store += read_pids if mode == :append
#
#     # Make sure the pid file is writable.
#     File.open(File.expand_path('tmp/pids/resque.pid', Rails.root), 'w') do |f|
#       f <<  pids_to_store.join(',')
#     end
#   end
#
#   def read_pids
#     pid_file_path = File.expand_path('tmp/pids/resque.pid', Rails.root)
#     return []  if ! File.exists?(pid_file_path)
#
#     File.open(pid_file_path, 'r') do |f|
#       f.read
#     end.split(',').collect {|p| p.to_i }
#   end
#
#   def stop_workers
#     pids = read_pids
#
#     if pids.empty?
#       puts "No workers to kill"
#     else
#       syscmd = "kill -s QUIT #{pids.join(' ')}"
#       puts "$ #{syscmd}"
#       `#{syscmd}`
#       store_pids([], :write)
#     end
#   end
#
#   # Start a worker with proper env vars and output redirection
#   def run_worker(queue, count = 1)
#     puts "Starting #{count} worker(s) with QUEUE: #{queue}"
#
#     ##  make sure log/resque_err, log/resque_stdout are writable.
#     ops = {:pgroup => true, :err => [(Rails.root + "log/resque_err").to_s, "a"],
#            :out => [(Rails.root + "log/resque_stdout").to_s, "a"]}
#     env_vars = {"QUEUE" => queue.to_s, 'RAILS_ENV' => Rails.env.to_s}
#
#     pids = []
#     count.times do
#       ## Using Kernel.spawn and Process.detach because regular system() call would
#       ## cause the processes to quit when capistrano finishes
#       pid = spawn(env_vars, "rake resque:work", ops)
#       Process.detach(pid)
#       pids << pid
#     end
#
#     store_pids(pids, :append)
#   end
# end



# require 'resque/tasks'
# require 'resque_scheduler/tasks'
#
# task "resque:setup" => :environment
# task "resque:scheduler_setup" => :environment
#
# namespace :resque do
#   task :setup do
#     require 'resque'
#     require 'resque_scheduler'
#     require 'resque/scheduler'
#     # Resque.redis = 'localhost:6379'
#     # ENV['QUEUE'] = '*'
#     if ENV['REDISCLOUD_URL']
#       uri = URI.parse(ENV['REDISCLOUD_URL'])
#       Resque.redis = {host: uri.host, port: uri.port, user: uri.user, password: uri.password}
#     else
#       Resque.redis = {host: 'localhost', port: '6379'}
#     end
#     Resque::Scheduler.dynamic = true
#     # Resque.schedule = YAML.load_file('config/resque_schedule.yml')
#     # Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))
#     Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
#     # require 'jobs'
#   end
# end
#
#
# # task "resque:setup" => :environment do
# #   ENV['QUEUE'] = '*'
# # end
# #
# # task "resque:scheduler_setup" => :environment
#
# desc "Alias for resque:work (To run workers on Heroku)"
# task "jobs:work" => "resque:work"