class CreateConceptResources < ActiveRecord::Migration
  def change
    create_table :concept_resources do |t|
      t.string :name
      t.text :desc
      t.integer :project_id
      #t.timestamps
    end
  end
end
