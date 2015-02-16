class AddCensoredToQuestionPosts < ActiveRecord::Migration
  def change
    add_column :question_posts, :censored, :boolean,  :default => false
    add_column :question_comments, :censored, :boolean,  :default => false
  end
end
