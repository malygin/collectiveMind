class NotificationObserver < ActiveRecord::Observer
  include ObserverHelper
  observe :journal

  def after_create(journal)
    Rails.logger.info "hello, it's after_create #{journal.id}"
    Rails.logger.info "personal: #{journal.personal}; viewed: #{journal.viewed}; user: #{journal.user_informed}"
    return unless journal.personal == true && journal.viewed == false && journal.user_informed.present?
    j_hash = prepare_journal_data(journal)
    Rails.logger.info j_hash
    Util::Publisher.publisher(j_hash, "notifications_#{journal.user_informed.id}")
  end
end
