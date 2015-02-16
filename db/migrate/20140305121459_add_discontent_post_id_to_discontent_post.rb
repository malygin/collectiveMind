class AddDiscontentPostIdToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :discontent_post_id, :integer
  end
end
