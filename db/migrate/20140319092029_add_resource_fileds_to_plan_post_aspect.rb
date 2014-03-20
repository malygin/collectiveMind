class AddResourceFiledsToPlanPostAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :positive_s, :text
    add_column :plan_post_aspects, :negative_s, :text
    add_column :plan_post_aspects, :control_s, :text
  end
end
