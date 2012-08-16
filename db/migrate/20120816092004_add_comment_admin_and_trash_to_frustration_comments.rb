class AddCommentAdminAndTrashToFrustrationComments < ActiveRecord::Migration
  def change
    add_column :frustration_comments, :comment_admin, :string
    add_column :frustration_comments, :trash, :boolean, :default => false

  end
end
