class AddAnonymToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :anonym, :boolean, default: false
  end
end
