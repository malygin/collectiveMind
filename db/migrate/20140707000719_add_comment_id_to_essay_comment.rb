class AddCommentIdToEssayComment < ActiveRecord::Migration
  def change
    add_column :essay_comments, :comment_id, :integer
  end
end
