Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
# Options
# Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.sleep_delay = 2
# Delayed::Worker.max_attempts = 5
# Delayed::Worker.max_run_time = 1.hour
# Delayed::Worker.read_ahead = 10
# Delayed::Worker.default_queue_name = 'default'
# Delayed::Worker.delay_jobs = !Rails.env.test?
# Delayed::Worker.raise_signal_exceptions = :term
# Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# if Rails.env.development?
#   system "RAILS_ENV=development #{Rails.root.join('bin','delayed_job')} restart"
#   # system "RAILS_ENV=development #{Rails.root.join('bin','delayed_job')} start"
# # elsif Rails.env.production?
# #   system "RAILS_ENV=production #{Rails.root.join('bin','delayed_job')} stop"
# #   system "RAILS_ENV=production #{Rails.root.join('bin','delayed_job')} -n 2 start"
# end
