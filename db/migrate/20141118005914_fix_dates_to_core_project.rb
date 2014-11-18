class FixDatesToCoreProject < ActiveRecord::Migration
  def change
    remove_column :core_projects, :date_12
    remove_column :core_projects, :date_23
    remove_column :core_projects, :date_34
    remove_column :core_projects, :date_45
    remove_column :core_projects, :date_56

    add_column :core_projects, :date_12, :timestamp
    add_column :core_projects, :date_23, :timestamp
    add_column :core_projects, :date_34, :timestamp
    add_column :core_projects, :date_45, :timestamp
    add_column :core_projects, :date_56, :timestamp
  end
end
