class RemoveValidateFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :validate, :boolean
  end
end
