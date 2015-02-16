class CoreProject < ActiveRecord::Migration
  def change
  	add_column :core_projects, :type_project, :integer, :default => 0
  	add_column :core_projects, :position, :integer, :default => 0

  end
end
