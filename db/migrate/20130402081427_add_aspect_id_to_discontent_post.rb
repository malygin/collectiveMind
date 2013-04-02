class AddAspectIdToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :aspect_id, :integer
    add_index :discontent_posts, :aspect_id
  end
end
