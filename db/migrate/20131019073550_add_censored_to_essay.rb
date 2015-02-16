class AddCensoredToEssay < ActiveRecord::Migration
  def change
    add_column :essay_posts, :censored, :boolean,  :default => false
    add_column :essay_comments, :censored, :boolean,  :default => false
  end
end
