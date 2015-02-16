class AddUserAddToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :discontent_aspects, :user_add, :boolean
  end
end
