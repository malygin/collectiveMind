class AddDefaultForScores < ActiveRecord::Migration
  def up
    change_column :core_project_users, :collect_info_posts_score, :integer, default: 0
    change_column :core_project_users, :discontent_posts_score, :integer, default: 0
    change_column :core_project_users, :concept_posts_score, :integer, default: 0
    change_column :core_project_users, :novation_posts_score, :integer, default: 0
    change_column :core_project_users, :plan_posts_score, :integer, default: 0
    change_column :core_project_users, :estimate_posts_score, :integer, default: 0
    change_column :core_project_users, :score, :integer, default: 0
  end

  def down
    change_column :core_project_users, :collect_info_posts_score, :integer
    change_column :core_project_users, :discontent_posts_score, :integer
    change_column :core_project_users, :concept_posts_score, :integer
    change_column :core_project_users, :novation_posts_score, :integer
    change_column :core_project_users, :plan_posts_score, :integer
    change_column :core_project_users, :estimate_posts_score, :integer
    change_column :core_project_users, :score, :integer
  end
end
