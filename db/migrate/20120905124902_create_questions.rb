class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :raiting, :default => 0
      t.integer :user_id

      t.timestamps
    end
    add_index :questions, :user_id
    add_index :questions, :created_at
  end
end
