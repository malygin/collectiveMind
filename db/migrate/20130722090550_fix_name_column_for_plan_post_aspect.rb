class FixNameColumnForPlanPostAspect < ActiveRecord::Migration
  def change
    rename_column :plan_post_aspects, :concept_post_id, :plan_post_id
  end
end
