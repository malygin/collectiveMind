class AddValueToUserCheck < ActiveRecord::Migration
  def change
    add_column :user_checks, :value, :string
  end
end
