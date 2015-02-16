class MoveStatusesFromGroupToTasks < ActiveRecord::Migration
  def change
    remove_column :groups, :status, :integer
    add_column :group_tasks, :status, :integer, default: 10
  end
end
