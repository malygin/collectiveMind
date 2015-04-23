class RemoveAspectIdFromDiscontentPost < ActiveRecord::Migration
  def change
    remove_column :discontent_posts, :aspect_id, :integer
  end
end
