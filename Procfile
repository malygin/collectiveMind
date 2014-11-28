web: bundle exec thin start -p $PORT
worker: COUNT=0  QUEUE=* bundle exec rake resque:work
scheduler: COUNT=0  bundle exec rake resque:scheduler
