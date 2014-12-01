# require 'resque/errors'

def mailer(users)
  events = Journal.events_for_user_mailer(1.day.ago.utc, users)
  g = events.group_by { |e| [e.user_informed, e.project_id] }
  feed_journals = g.collect { |k, v| [v.first.user_informed.id, v.first.project, v.size] }

  h = {}
  feed_journals.each do |arr|
    h[arr[0]] ||= []
    h[arr[0]] << [arr[1],arr[2]]
  end

  h.each do |k,v|
    PostMailer.feed_mailer(k,v).deliver
  end
end

class FeedModeratorMailer
  @queue = :feed_moderator_mailer

  def self.perform
    moderators = User.where(users: {type_user: User::TYPES_USER[:admin]})
    mailer(moderators)
  end
end

class FeedUserMailer
  @queue = :feed_user_mailer

  def self.perform
    users = User.where(users: { type_user: [2,3,4,5,8,nil] })
    mailer(users)
  end
end

class ModeratorMailer
  @queue = :moderator_mailer

  def self.perform
    mails = JournalMailer.where(journal_mailers: { sent: ['f',nil], status: 0 }).where("journal_mailers.created_at >= ?", 3.day.ago.utc)
    mails.each do |mail|
      project = Core::Project.find(mail.project_id)
      if project.type_access == 2
        users_in_project = project.users_in_project
        if users_in_project
          users_in_project.each do |user|
            PostMailer.moderator_mailer(user.id,mail.id).deliver
          end
        end
      end
      mail.update_attributes(sent: true)
    end
  end
end

class StagesMailer
  @queue = :stages_mailer

  def self.perform
    now = 1.day.ago.utc
    closed_projects = Core::Project.active_proc.access_proc(2).where("date12 >= ? OR date23 >= ? OR date34 >= ? OR date45 >= ?", now,now,now,now)
    if closed_projects
      closed_projects.each do |project|
        users_in_project = project.users_in_project
        if users_in_project
          users_in_project.each do |user|
            PostMailer.stages_mailer(user.id,project.id).deliver
          end
        end
      end
    end
  end
end


class LogTask
  @queue = :log_proc

  def self.perform
    Rails.logger.info "hello, it's #{Time.now}"
  end

end