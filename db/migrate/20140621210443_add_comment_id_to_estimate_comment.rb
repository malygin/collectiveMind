class AddCommentIdToEstimateComment < ActiveRecord::Migration
  def change
    add_column :estimate_comments, :comment_id, :integer
  end
end
