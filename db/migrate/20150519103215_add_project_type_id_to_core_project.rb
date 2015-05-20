class AddProjectTypeIdToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :project_type_id, :integer
  end
end
