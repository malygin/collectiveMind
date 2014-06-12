class AddPostStageToPlanPostAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :post_stage_id, :integer
  end
end
