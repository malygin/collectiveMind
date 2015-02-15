class AddUserAddToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :core_aspects, :user_add, :boolean
  end
end
