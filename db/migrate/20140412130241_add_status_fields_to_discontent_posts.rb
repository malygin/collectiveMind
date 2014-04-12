class AddStatusFieldsToDiscontentPosts < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :status_content, :boolean
    add_column :discontent_posts, :status_whered, :boolean
    add_column :discontent_posts, :status_whend, :boolean
  end
end
