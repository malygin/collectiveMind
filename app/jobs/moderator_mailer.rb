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