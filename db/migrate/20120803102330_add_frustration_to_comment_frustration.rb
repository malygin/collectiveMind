class AddFrustrationToCommentFrustration < ActiveRecord::Migration
  def change
    add_column :comment_frustrations, :frustration_id, :integer
  end
end
