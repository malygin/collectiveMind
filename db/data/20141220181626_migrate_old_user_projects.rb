class MigrateOldUserProjects < SeedMigration::Migration
  def up
    Core::ProjectUser.each do |project_user|
      project_user
    end
  end

  def down

  end
end
