class RemoveStatusFromProject < ActiveRecord::Migration
  def change
    remove_column :core_project_users, :status, :integer
  end
end
