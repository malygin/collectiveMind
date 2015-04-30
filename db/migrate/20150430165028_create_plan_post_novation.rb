class CreatePlanPostNovation < ActiveRecord::Migration
  def change
    create_table :plan_post_novations do |t|
      t.integer :novation_post_id
      t.integer :plan_post_id

      t.string :title

      t.text :project_change
      t.text :project_goal
      t.text :project_members
      t.text :project_results
      t.text :project_time

      t.text :members_new
      t.text :members_who
      t.text :members_education
      t.text :members_motivation
      t.text :members_execute

      t.text :resource_commands
      t.text :resource_support
      t.text :resource_internal
      t.text :resource_external
      t.text :resource_financial
      t.text :resource_competition

      t.text :confidence_commands
      t.text :confidence_remove_discontent
      t.text :confidence_negative_results

      t.boolean :project_change_bool
      t.boolean :project_goal_bool
      t.boolean :project_members_bool
      t.boolean :project_results_bool
      t.boolean :project_time_bool

      t.boolean :members_new_bool
      t.boolean :members_who_bool
      t.boolean :members_education_bool
      t.boolean :members_motivation_bool
      t.boolean :members_execute_bool

      t.boolean :resource_commands_bool
      t.boolean :resource_support_bool
      t.boolean :resource_internal_bool
      t.boolean :resource_external_bool
      t.boolean :resource_financial_bool
      t.boolean :resource_competition_bool

      t.boolean :confidence_commands_bool
      t.boolean :confidence_remove_discontent_bool
      t.boolean :confidence_negative_results_bool

      t.timestamps null: false
    end
  end
end
