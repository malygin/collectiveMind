# require 'resque/errors'

class FeedModeratorMailer
  @queue = :feed_mailer

  # include Resque::Plugins::Status

  # def self.queue
  #   :my_sleep
  # end

  def self.perform
    moderators = User.where(users: {type_user: User::TYPES_USER[:admin]})
    events = Journal.events_for_moderator_mailer(Time.now.utc.yesterday, moderators)

    g = events.group_by { |e| [e.user_informed, e.project_id] }
    feed_journals = g.collect { |k, v| [v.first.user_informed.id, v.first.project, v.size] }

    h = {}
    feed_journals.each do |arr|
      h[arr[0]] ||= []
      h[arr[0]] << [arr[1],arr[2]]
    end

    h.each do |k,v|
      PostMailer.feed_moderator(k,v).deliver
    end

    # Rails.logger.info "hello, it's #{Time.now}"
  end

end