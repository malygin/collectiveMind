class AddPlanFirstAndPlanOtherToPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :plan_first, :text
    add_column :plan_posts, :plan_other, :text
  end
end
