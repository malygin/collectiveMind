class AddOwnerToGroups < ActiveRecord::Migration
  def change
    add_column :group_users, :owner, :boolean, default: false
  end
end
