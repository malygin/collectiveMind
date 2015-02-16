class DeleteCommentIdFromAdviceComments < ActiveRecord::Migration
  def change
    remove_column :advice_comments, :post_advice_comment_id, :integer
  end
end
