class CreateConceptEssays < ActiveRecord::Migration
  def change
    create_table :concept_essays do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
