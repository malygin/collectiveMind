class AddCommentAdminAndTrashToFrustration < ActiveRecord::Migration
  def change
    add_column :frustrations, :comment_admin, :string
    add_column :frustrations, :trash, :boolean, :default => false
  end
end
