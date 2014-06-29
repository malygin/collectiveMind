class AddPersonalToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :personal, :boolean, :default => false
  end
end
