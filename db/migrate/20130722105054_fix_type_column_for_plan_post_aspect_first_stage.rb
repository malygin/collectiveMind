class FixTypeColumnForPlanPostAspectFirstStage < ActiveRecord::Migration
  def change
    change_column :plan_post_aspects, :first_stage,'integer USING CAST(first_stage AS integer)'
  end
end
