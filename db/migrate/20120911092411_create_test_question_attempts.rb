class CreateTestQuestionAttempts < ActiveRecord::Migration
  def change
    create_table :test_question_attempts do |t|
      t.integer :test_attempt_id
      t.integer :test_question_id
      t.string :answer
      t.timestamps
    end
    add_index :test_question_attempts, :test_attempt_id
    add_index :test_question_attempts, :test_question_id
  end
end
