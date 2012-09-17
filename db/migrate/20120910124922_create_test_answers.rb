class CreateTestAnswers < ActiveRecord::Migration
  def change
    create_table :test_answers do |t|
      t.text :name
      t.integer :type_answer
      t.integer :test_question_id
      t.timestamps
    end
    add_index :test_answers, :test_question_id
  end
end
