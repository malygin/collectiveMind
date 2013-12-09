class AddSecondNeprAndAllGradeForEstimatePostAspect < ActiveRecord::Migration
  def change
    add_column :estimate_post_aspects,  :nep1, :integer
    add_column :estimate_post_aspects,  :nep2, :integer
    add_column :estimate_post_aspects,  :nep3, :integer
    add_column :estimate_post_aspects,  :nep4, :integer
    add_column :estimate_post_aspects,  :nep, :text
    add_column :estimate_post_aspects,  :all_grade, :integer

  end
end
