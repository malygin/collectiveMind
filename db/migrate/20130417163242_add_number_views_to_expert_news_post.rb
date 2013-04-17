class AddNumberViewsToExpertNewsPost < ActiveRecord::Migration
  def change
    add_column :expert_news_posts, :number_views, :integer, :default => 0
  end
end
