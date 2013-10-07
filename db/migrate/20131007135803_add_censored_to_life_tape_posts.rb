class AddCensoredToLifeTapePosts < ActiveRecord::Migration
  def change
    add_column :life_tape_posts, :censored, :boolean,  :default => false
    add_column :discontent_posts, :censored, :boolean,  :default => false
    add_column :life_tape_comments, :censored, :boolean, :default => false
    add_column :discontent_comments, :censored, :boolean, :default => false
  end
end
