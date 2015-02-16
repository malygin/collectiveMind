class AddProjectIdToPlanPostsAndEstimatePosts < ActiveRecord::Migration
  def change
    add_column :plan_posts, :project_id, :integer
    add_column :estimate_posts, :project_id, :integer
    add_index :plan_posts, :project_id
    add_index :estimate_posts, :project_id
  end
end
