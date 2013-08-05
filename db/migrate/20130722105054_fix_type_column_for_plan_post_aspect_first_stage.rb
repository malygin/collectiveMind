class FixTypeColumnForPlanPostAspectFirstStage < ActiveRecord::Migration
  def change
    change_column :plan_post_aspects, :first_stage, :integer
  end
end
