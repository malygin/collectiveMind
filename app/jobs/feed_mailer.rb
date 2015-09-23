# require 'resque/errors'

def mailer(users)
  events = Journal.events_for_user_mailer(1.day.ago.utc, users)
  g = events.group_by { |e| [e.user_informed, e.project_id] }
  feed_journals = g.collect { |_, v| [v.first.user_informed.id, v.first.project, v.size] }

  h = {}
  feed_journals.each do |arr|
    h[arr[0]] ||= []
    h[arr[0]] << [arr[1], arr[2]]
  end

  h.each { |k, v| PostMailer.feed_mailer(k, v).deliver }
end

# рассылка о непрочитанных уведомлениях у модераторов
class FeedModeratorMailer
  @queue = :feed_moderator_mailer

  def self.perform
    moderators = User.where(users: { type_user: 1 })
    mailer(moderators)
  end
end

# рассылка о непрочитанных уведомлениях у пользователей
class FeedUserMailer
  @queue = :feed_user_mailer

  def self.perform
    users = User.where(users: { type_user: [0, nil] })
    mailer(users)
  end
end
