class CreateCoreProjectSettings < ActiveRecord::Migration
  def up
    create_table :core_project_settings do |t|
      t.json :stage_dates
      t.references :project, index: true, null: false

      t.timestamps
    end

    Core::Project.all.each do |project|
      Core::ProjectSetting.create project: project
    end
  end

  def down
    drop_table :core_project_settings
  end
end
