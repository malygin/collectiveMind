class CreateConceptFinalVoitings < ActiveRecord::Migration
  def change
    create_table :concept_final_voitings do |t|
      t.integer :score
      t.integer :forecast_task_id
      t.integer :user_id

      t.timestamps
    end
    add_index :concept_final_voitings, :user_id
    add_index :concept_final_voitings, :forecast_task_id

  end
end
