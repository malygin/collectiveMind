class AddControlRFiledsToPlanPostAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :control_r, :text

  end
end
