class RemoveColumnsToUser < ActiveRecord::Migration
  def up
     remove_column :users, :admin
     remove_column :users, :expert
     remove_column :users, :jury
     remove_column :users, :user_type
  end

  def down
     add_column :users, :admin, :boolean, :default => false
     add_column :users, :expert, :boolean, :default => false
     add_column :users, :jury, :boolean, :default => false
     add_column :users, :user_type, :string
  end
end
