class AddNameToPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :name, :string
  end
end
