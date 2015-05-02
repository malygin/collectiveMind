class CreateCoreContentUserAnswers < ActiveRecord::Migration
  def change
    create_table :core_content_user_answers do |t|
      t.text :content
      t.integer :content_question_id
      t.integer :content_answer_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
