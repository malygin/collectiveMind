class RenameForeignKeys < ActiveRecord::Migration
  def change
    rename_column :technique_list_projects, :core_project_id, :project_id
  end
end
