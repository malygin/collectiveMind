class AddAnonymToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :anonym, :boolean,  default: false
  end
end
