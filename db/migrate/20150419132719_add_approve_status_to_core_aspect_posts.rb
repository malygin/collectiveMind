class AddApproveStatusToCoreAspectPosts < ActiveRecord::Migration
  def change
    add_column :core_aspect_posts, :approve_status, :boolean
  end
end
