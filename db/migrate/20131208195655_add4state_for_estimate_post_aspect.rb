class Add4stateForEstimatePostAspect < ActiveRecord::Migration
  def change
      add_column :estimate_post_aspects,  :op4, :integer
      add_column :estimate_post_aspects,  :ozf4, :integer
      add_column :estimate_post_aspects,  :ozs4, :integer
      add_column :estimate_post_aspects,  :on4, :integer

  end
end
