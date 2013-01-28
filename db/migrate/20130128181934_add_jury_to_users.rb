class AddJuryToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :jury, :boolean, :default =>false
  end
end
