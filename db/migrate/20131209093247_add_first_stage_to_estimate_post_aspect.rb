class AddFirstStageToEstimatePostAspect < ActiveRecord::Migration
  def change
    add_column :estimate_post_aspects, :first_stage, :boolean
  end
end
