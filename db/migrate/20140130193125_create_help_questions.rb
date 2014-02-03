class CreateHelpQuestions < ActiveRecord::Migration
  def change
    create_table :help_questions do |t|
      t.text :content
      t.integer :post_id
      t.integer :order
      t.integer :style

      t.timestamps
    end
  end
end
