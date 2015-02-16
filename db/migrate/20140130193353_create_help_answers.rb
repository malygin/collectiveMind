class CreateHelpAnswers < ActiveRecord::Migration
  def change
    create_table :help_answers do |t|
      t.text :content
      t.integer :question_id
      t.integer :order

      t.timestamps
    end
  end
end
