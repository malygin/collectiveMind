class AddCommentIdToPlanComment < ActiveRecord::Migration
  def change
    add_column :plan_comments, :comment_id, :integer
  end
end
