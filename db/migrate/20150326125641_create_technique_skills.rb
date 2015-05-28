class CreateTechniqueSkills < ActiveRecord::Migration
  def change
    create_table :technique_skills do |t|
      t.references :technique_list, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
