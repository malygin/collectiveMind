class AddReadyToPlanToProjectUsers < ActiveRecord::Migration
  def change
    add_column :core_project_users, :ready_to_plan, :boolean, default: false
  end
end
