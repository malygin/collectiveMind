class AddProjectIdToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :project_id, :integer
    add_index :journals, :project_id
  end
end
