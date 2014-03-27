class AddUserInformedToJournal < ActiveRecord::Migration
  def change
    add_column :journals, :user_informed, :integer
  end
end
