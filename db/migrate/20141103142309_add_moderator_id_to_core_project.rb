class AddModeratorIdToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :moderator_id, :integer
  end
end
