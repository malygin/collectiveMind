class RenameTypeProcedure < ActiveRecord::Migration
  def change
    rename_column :core_projects, :type_procedure, :project_type_id
  end
end
