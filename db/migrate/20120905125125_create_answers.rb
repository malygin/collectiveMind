class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :text
      t.integer :raiting, :default => 0
      t.integer :user_id
      t.integer :question_id

      t.timestamps
    end
    add_index :answers, :user_id
    add_index :answers, :created_at
  end
end
