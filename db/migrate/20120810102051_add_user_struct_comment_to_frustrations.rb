class AddUserStructCommentToFrustrations < ActiveRecord::Migration
  def change
    add_column :frustrations, :struct_user_id, :integer
  end
end
