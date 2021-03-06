class CreateNovationTechnique < SeedMigration::Migration
  def up
    technique = Technique::List.create! stage: 'novation_posts', code: 'simple'
    Core::Project.all.each do |project|
      project.technique_list_projects.create! technique_list: technique
    end
  end

  def down
    Technique::List.find_by(stage: 'novation_posts', code: 'simple').destroy
  end
end
