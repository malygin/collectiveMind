class AddProjectVotintToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :stage1, :integer, :default => 5
    add_column :core_projects, :stage2, :integer, :default => 5
    add_column :core_projects, :stage3, :integer, :default => 5
    add_column :core_projects, :stage4, :integer, :default => 5
    add_column :core_projects, :stage5, :integer, :default => 5
  end
end
