class AddContentToPlanPosts < ActiveRecord::Migration
  def change
    add_column :plan_posts, :content, :text
  end
end
