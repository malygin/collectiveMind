class AddIndeciesToJournal < ActiveRecord::Migration
  def change
    add_index :journals, [:project_id, :type_event]
  end
end
