class AddScoreFieldsForProjectUsers < ActiveRecord::Migration
  def change
    add_column :core_project_users, :collect_info_posts_score, :integer
    add_column :core_project_users, :discontent_posts_score, :integer
    add_column :core_project_users, :concept_posts_score, :integer
    add_column :core_project_users, :novation_posts_score, :integer
    add_column :core_project_users, :plan_posts_score, :integer
    add_column :core_project_users, :estimate_posts_score, :integer
    add_column :core_project_users, :score, :integer
  end
end
