# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run CollectiveMind::Application

# require 'resque/server'
# require 'resque/status_server'

# run Rack::URLMap.new \
#   "/" => CollectiveMind::Application,
#   "/resque" => Resque::Server.new
