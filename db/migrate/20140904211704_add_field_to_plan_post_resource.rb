class AddFieldToPlanPostResource < ActiveRecord::Migration
  def change
    add_column :plan_post_resources, :plan_post_resource_id, :integer
    add_column :plan_post_resources, :style, :integer
  end
end
