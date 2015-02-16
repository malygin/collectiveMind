class CreateQuestionPostVotings < ActiveRecord::Migration
  def change
    create_table :question_post_votings do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
    add_index :question_post_votings, :post_id
  end
end
