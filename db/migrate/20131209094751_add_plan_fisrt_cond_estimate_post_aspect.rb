class AddPlanFisrtCondEstimatePostAspect < ActiveRecord::Migration
  def change
    add_column :estimate_post_aspects, :plan_post_first_cond_id, :integer

  end
end
