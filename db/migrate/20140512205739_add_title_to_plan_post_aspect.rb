class AddTitleToPlanPostAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :title, :text
  end
end
