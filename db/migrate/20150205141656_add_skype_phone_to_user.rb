class AddSkypePhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :skype, :string
    add_column :users, :phone, :string
  end
end
