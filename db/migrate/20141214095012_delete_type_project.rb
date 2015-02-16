class DeleteTypeProject < ActiveRecord::Migration
  def change
    remove_column :core_projects, :type_project, :integer, default: 0
  end
end
