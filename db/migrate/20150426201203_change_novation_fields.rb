class ChangeNovationFields < ActiveRecord::Migration
  def change
    remove_column :novation_posts, :actions_desc, :text
    remove_column :novation_posts, :actions_ground, :text
    remove_column :novation_posts, :actors, :text
    remove_column :novation_posts, :tools, :text
    remove_column :novation_posts, :impact_group, :text
    remove_column :novation_posts, :impact_env, :text

    add_column :novation_posts, :project_change, :text
    add_column :novation_posts, :project_goal, :text
    add_column :novation_posts, :project_members, :text
    add_column :novation_posts, :project_results, :text
    add_column :novation_posts, :project_time, :text

    add_column :novation_posts, :members_new, :text
    add_column :novation_posts, :members_who, :text
    add_column :novation_posts, :members_education, :text
    add_column :novation_posts, :members_motivation, :text
    add_column :novation_posts, :members_execute, :text

    add_column :novation_posts, :resource_commands, :text
    add_column :novation_posts, :resource_support, :text
    add_column :novation_posts, :resource_internal, :text
    add_column :novation_posts, :resource_external, :text
    add_column :novation_posts, :resource_financial, :text
    add_column :novation_posts, :resource_competition, :text

    add_column :novation_posts, :confidence_commands, :text
    add_column :novation_posts, :confidence_remove_discontent, :text
    add_column :novation_posts, :confidence_negative_results, :text
  end
end
