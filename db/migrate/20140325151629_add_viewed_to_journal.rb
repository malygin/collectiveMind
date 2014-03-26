class AddViewedToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :viewed, :boolean
  end
end
