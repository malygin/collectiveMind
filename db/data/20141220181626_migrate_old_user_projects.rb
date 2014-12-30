class MigrateOldUserProjects < SeedMigration::Migration
  def up
    Core::ProjectUser.all.each do |project_user|
      # 1, 6, 7 в модератора
      # 2 в эксперта
      # остальных - в рядовых участников
      # дополнительная проверка, потому что для удаленных пользователей сохраняется связь с проектом
      unless project_user.user.nil?
        if [1, 6, 7].include? project_user.user.type_user
          project_user.type_user = 1
        elsif project_user.user.type_user == 2
          project_user.type_user = 2
        else
          project_user.type_user = 3
        end
      end

      project_user.save
    end

    User.where(type_user: User::TYPES_USER[:admin]).each do |user|
      Core::Project.all.each do |project|
        unless user.core_project_users.by_project(project.id).first
          user.core_project_users.create(project_id: project.id, type_user: 1)
        end
      end
    end
  end

  def down
    Core::ProjectUser.update_all(type_user: nil)
  end
end
