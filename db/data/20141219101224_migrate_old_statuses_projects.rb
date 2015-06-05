class MigrateOldStatusesProjects < SeedMigration::Migration
  def up
    Core::Project.where.not(type_access: Core::Project::TYPE_ACCESS.values).each do |project|
      project.update_attributes! type_access: Core::Project::TYPE_ACCESS[:closed]
    end
  end

  def down
    puts 'Not back migration'
  end
end
