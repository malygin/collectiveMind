class CreateCoreProjectScores < ActiveRecord::Migration
  def change
    create_table :core_project_scores do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :score
      t.integer :score_a
      t.integer :score_g
      t.integer :score_o

      t.timestamps
    end
  end
end
