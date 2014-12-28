class StagesMailer
  @queue = :stages_mailer

  def self.perform
    now = 1.day.ago.utc
    closed_projects = Core::Project.active_proc.access_proc(2).where('"core_projects"."date_12" >= ? OR "core_projects"."date_23" >= ? OR "core_projects"."date_34" >= ? OR "core_projects"."date_45" >= ?', now,now,now,now)
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