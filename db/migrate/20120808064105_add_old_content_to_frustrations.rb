class AddOldContentToFrustrations < ActiveRecord::Migration
  def change
    add_column :frustrations, :old_content, :string
    add_column :frustrations, :negative_user_id, :integer
  end
end
