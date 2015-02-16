class AddPlanControlToPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :plan_control, :text
  end
end
