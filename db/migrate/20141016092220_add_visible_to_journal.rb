class AddVisibleToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :visible, :boolean, :default => true
  end
end
