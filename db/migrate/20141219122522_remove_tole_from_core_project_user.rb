class RemoveToleFromCoreProjectUser < ActiveRecord::Migration
  def change
    remove_column :core_project_users, :role_id, :integer
    add_column :core_project_users, :type_user, :integer
  end
end
