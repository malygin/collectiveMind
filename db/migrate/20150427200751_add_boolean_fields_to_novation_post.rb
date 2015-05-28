class AddBooleanFieldsToNovationPost < ActiveRecord::Migration
  def change
    add_column :novation_posts, :project_change_bool, :boolean
    add_column :novation_posts, :project_goal_bool, :boolean
    add_column :novation_posts, :project_members_bool, :boolean
    add_column :novation_posts, :project_results_bool, :boolean
    add_column :novation_posts, :project_time_bool, :boolean

    add_column :novation_posts, :members_new_bool, :boolean
    add_column :novation_posts, :members_who_bool, :boolean
    add_column :novation_posts, :members_education_bool, :boolean
    add_column :novation_posts, :members_motivation_bool, :boolean
    add_column :novation_posts, :members_execute_bool, :boolean

    add_column :novation_posts, :resource_commands_bool, :boolean
    add_column :novation_posts, :resource_support_bool, :boolean
    add_column :novation_posts, :resource_internal_bool, :boolean
    add_column :novation_posts, :resource_external_bool, :boolean
    add_column :novation_posts, :resource_financial_bool, :boolean
    add_column :novation_posts, :resource_competition_bool, :boolean

    add_column :novation_posts, :confidence_commands_bool, :boolean
    add_column :novation_posts, :confidence_remove_discontent_bool, :boolean
    add_column :novation_posts, :confidence_negative_results_bool, :boolean
  end
end
