class NotificationObserver < ActiveRecord::Observer
  include ObserverHelper
  observe :journal

  def after_create(journal)
    # если это личное уведомление, то отправляем json в пользовательский канал
    return unless journal.personal == true && journal.viewed == false && journal.user_informed.present?
    j_hash = prepare_journal_data(journal)
    Util::Publisher.publisher(j_hash, "notifications_#{journal.user_informed.id}")
  end
end
