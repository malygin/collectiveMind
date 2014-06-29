class RefacJournal < ActiveRecord::Migration
  def change
    add_column :journals, :event, :integer
    add_column :journals, :first_id, :integer
    add_column :journals, :second_id, :integer
  end
end
