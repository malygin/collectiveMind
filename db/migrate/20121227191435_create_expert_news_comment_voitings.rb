class CreateExpertNewsCommentVoitings < ActiveRecord::Migration
  def change
    create_table :expert_news_comment_voitings do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
    add_index :expert_news_comment_voitings, :comment_id
  end
end
