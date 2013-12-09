class AddSecondNeprAndAllGradeForEstimatePost < ActiveRecord::Migration
  def change
    remove_column :estimate_post_aspects,  :nep1, :integer
    remove_column :estimate_post_aspects,  :nep2, :integer
    remove_column :estimate_post_aspects,  :nep3, :integer
    remove_column :estimate_post_aspects,  :nep4, :integer
    remove_column :estimate_post_aspects,  :nep, :text
    remove_column :estimate_post_aspects,  :all_grade, :integer

    add_column :estimate_posts,  :nep1, :integer
    add_column :estimate_posts,  :nep2, :integer
    add_column :estimate_posts,  :nep3, :integer
    add_column :estimate_posts,  :nep4, :integer
    add_column :estimate_posts,  :nep, :text
    add_column :estimate_posts,  :all_grade, :integer
  end
end
