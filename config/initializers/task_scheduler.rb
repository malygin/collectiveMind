# p "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
# p $$
# require 'rufus-scheduler'
#
# # scheduler = Rufus::Scheduler.new
# s = Rufus::Scheduler.singleton
#
# # trap('TERM') do
# #   s.shutdown(:kill)
# #   p :bye
# #   exit
# # end
#
# s.every '1m' do
#   Rails.logger.info "hello, it's #{Time.now}"
# end
#
# # class Handler
# #   def self.call(job, time)
# #     p "- Handler called for #{job.id} at #{time}"
# #   end
# # end
#
# # unless scheduler.down?
# #
# #   scheduler.every("10s") do
# #     puts 'Set every job...'
# #   end
# # end