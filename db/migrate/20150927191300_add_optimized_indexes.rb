class AddOptimizedIndexes < ActiveRecord::Migration
  def change
    add_index :journal_loggers, [:user_id, :project_id, :type_event]
    remove_index :journal_loggers, :user_informed
  end
end
