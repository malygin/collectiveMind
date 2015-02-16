class AddEstimateStatusToPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :estimate_status, :integer
  end
end
