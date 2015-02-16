class AddFieldToEssayPost < ActiveRecord::Migration
  def change
    add_column :essay_posts, :negative, :text
    add_column :essay_posts, :positive, :text
    add_column :essay_posts, :change, :text
    add_column :essay_posts, :reaction, :text
  end
end
