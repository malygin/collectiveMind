class AddWhatToDiscontentPosts < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :what, :text
  end
end
