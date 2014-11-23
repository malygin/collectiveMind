# require 'resque/errors'

class SleepingJob
  @queue = :sleeping_job

  # include Resque::Plugins::Status

  # def self.queue
  #   :my_sleep
  # end

  def self.perform
    # puts 'I like to sleep'
    Rails.logger.info "hello, it's #{Time.now}"
    # sleep 2

    # rescue Resque::TermException
    # puts "omg job cleaned up!!!!"
  end
  # def perform
  #   puts 'I like to sleep'
  #   sleep 2
  #   # rescue Resque::TermException
  #   # puts "omg job cleaned up!!!!"
  # end
end