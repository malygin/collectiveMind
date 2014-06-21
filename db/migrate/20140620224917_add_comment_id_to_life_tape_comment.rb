class AddCommentIdToLifeTapeComment < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :comment_id, :integer
  end
end
