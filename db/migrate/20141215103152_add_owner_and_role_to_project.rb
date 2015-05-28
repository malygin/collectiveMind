class AddOwnerAndRoleToProject < ActiveRecord::Migration
  def change
    add_column :core_project_users, :owner, :boolean, default: false
    add_column :core_project_users, :role_id, :integer
  end
end
