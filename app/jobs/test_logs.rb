class LogTask
  @queue = :log_proc

  def self.perform
    Rails.logger.info "hello, it's #{Time.now}"
  end
end
