class CreateQuestionCommentVotings < ActiveRecord::Migration
  def change
    create_table :question_comment_votings do |t|
      t.integer :user_id
      t.integer :comment_id
      t.timestamps
    end
    add_index :question_comment_votings, :comment_id
  end
end
