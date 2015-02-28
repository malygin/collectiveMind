class FillByDefaultFields < ActiveRecord::Migration
  def up
    change_column :plan_posts, :number_views, :integer, default: 0
    change_column :plan_posts, :status, :integer, default: 0
    change_column :plan_post_stages, :status, :integer, default: 0
    change_column :plan_post_actions, :status, :integer, default: 0
  end

  def down
    change_column :plan_posts, :number_views, :integer
    change_column :plan_posts, :status, :integer
    change_column :plan_post_stages, :status, :integer
    change_column :plan_post_actions, :status, :integer
  end
end
