class AddCensoredToPlan < ActiveRecord::Migration
  def change
    add_column :plan_posts, :censored, :boolean,  :default => false
    add_column :plan_comments, :censored, :boolean,  :default => false
  end
end
