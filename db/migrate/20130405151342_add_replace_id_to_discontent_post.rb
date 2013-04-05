class AddReplaceIdToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :replace_id, :integer
  end
end
