class CreateTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_questions do |t|
      t.text :name
      t.integer :type_question
      t.integer :test_id
      t.timestamps
    end
    add_index :test_questions, :test_id
  end
end
