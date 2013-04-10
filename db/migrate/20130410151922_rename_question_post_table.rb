class RenameQuestionPostTable < ActiveRecord::Migration
  def up
  	rename_table :questions_posts, :question_posts
  end

  def down
  	rename_table :question_posts, :questions_posts
  end
end
