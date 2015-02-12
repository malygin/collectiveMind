class AddReadyToCoreProjectUsers < ActiveRecord::Migration
  def change
    add_column :core_project_users, :ready_to_concept, :boolean, default: false
  end
end
