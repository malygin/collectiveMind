class RenameTable < ActiveRecord::Migration
  def change
    rename_table :knowbase_posts, :core_knowbase_posts
  end
end
