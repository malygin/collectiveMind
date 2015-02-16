class AddFieldDateToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :date_12, :integer
    add_column :core_projects, :date_23, :integer
    add_column :core_projects, :date_34, :integer
    add_column :core_projects, :date_45, :integer
    add_column :core_projects, :date_56, :integer
  end
end
