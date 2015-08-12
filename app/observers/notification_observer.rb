class NotificationObserver < ActiveRecord::Observer
  include ObserverHelper
  observe :journal

  def after_create(journal)
    Rails.logger.info "hello, it's after_create #{journal.id}"
    Rails.logger.info "personal: #{journal.personal}; viewed: #{journal.viewed}; user: #{journal.user_informed}"
    # Rails.logger.info journal.to_json(:except => [:user_informed])
    return unless journal.personal == true && journal.viewed == false && journal.user_informed.present?
    j_hash = prepare_journal_data(journal)
    Rails.logger.info j_hash
    Util::Publisher.publisher(j_hash, "notifications_#{journal.user_informed.id}")
    # $pubnub.publish(message: journal.to_json(:except => [:user_informed]), channel: "notifications_#{journal.user_informed.id}",
    #                 callback: lambda { |envelope| puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end