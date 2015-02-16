class AddStepForPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :step, :integer,  :default => 1
  end
end
