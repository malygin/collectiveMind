class AddNewFieldsToPlanAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :positive_r, :text
    add_column :plan_post_aspects, :negative_r, :text
    add_column :plan_post_aspects, :obstacles, :text
  end
end
