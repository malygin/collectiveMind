class AddStatusToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :status, :integer, default: 10
  end
end
