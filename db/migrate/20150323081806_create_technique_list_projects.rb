class CreateTechniqueListProjects < ActiveRecord::Migration
  def change
    create_table :technique_list_projects do |t|
      t.references :core_project, index: true, foreign_key: true
      t.references :technique_list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
