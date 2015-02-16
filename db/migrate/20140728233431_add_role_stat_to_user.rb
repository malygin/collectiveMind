class AddRoleStatToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_stat, :integer
  end
end
