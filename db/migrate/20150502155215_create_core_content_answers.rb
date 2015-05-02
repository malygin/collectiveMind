class CreateCoreContentAnswers < ActiveRecord::Migration
  def change
    create_table :core_content_answers do |t|
      t.text :content
      t.integer :content_question_id

      t.timestamps null: false
    end
  end
end
