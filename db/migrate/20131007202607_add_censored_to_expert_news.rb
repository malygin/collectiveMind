class AddCensoredToExpertNews < ActiveRecord::Migration
  def change
    add_column :expert_news_posts, :censored, :boolean,  :default => false
    add_column :expert_news_comments, :censored, :boolean,  :default => false
  end
end
