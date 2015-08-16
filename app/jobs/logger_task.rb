# LoggerJob = Struct.new do
#   def perform
#     Rails.logger.info "hello, it's #{Time.now}"
#   end
# end
#
# class ParanoidNewsletterJob < NewsletterJob
#   def enqueue(job)
#     record_stat 'newsletter_job/enqueue'
#   end
# end

class ProcessLoggerJob
  def self.perform
    Rails.logger.info "hello, it's #{Time.now}"
  end
end