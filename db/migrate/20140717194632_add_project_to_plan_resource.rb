class AddProjectToPlanResource < ActiveRecord::Migration
  def change
    add_column :plan_post_resources, :project_id, :integer
    add_column :plan_post_action_resources, :project_id, :integer
    add_column :plan_post_means, :project_id, :integer
  end
end
