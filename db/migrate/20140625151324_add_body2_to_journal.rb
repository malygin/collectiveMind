class AddBody2ToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :body2, :string
  end
end
