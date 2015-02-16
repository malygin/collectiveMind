class AddCommentIdToDiscontentComment < ActiveRecord::Migration
  def change
    add_column :discontent_comments, :comment_id, :integer
  end
end
