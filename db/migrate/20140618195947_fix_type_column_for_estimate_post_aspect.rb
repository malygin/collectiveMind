class FixTypeColumnForEstimatePostAspect < ActiveRecord::Migration
  def change
    change_column :estimate_post_aspects, :op1, :float
    change_column :estimate_post_aspects, :op2, :float
    change_column :estimate_post_aspects, :op3, :float
    change_column :estimate_post_aspects, :op4, :float

    change_column :estimate_post_aspects, :on1, :float
    change_column :estimate_post_aspects, :on2, :float
    change_column :estimate_post_aspects, :on3, :float
    change_column :estimate_post_aspects, :on4, :float

    change_column :estimate_post_aspects, :ozf1, :float
    change_column :estimate_post_aspects, :ozf2, :float
    change_column :estimate_post_aspects, :ozf3, :float
    change_column :estimate_post_aspects, :ozf4, :float

    change_column :estimate_post_aspects, :ozs1, :float
    change_column :estimate_post_aspects, :ozs2, :float
    change_column :estimate_post_aspects, :ozs3, :float
    change_column :estimate_post_aspects, :ozs4, :float
  end
end
