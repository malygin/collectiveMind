class AddStyleToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :style, :integer
  end
end
