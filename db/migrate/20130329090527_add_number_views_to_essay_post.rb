class AddNumberViewsToEssayPost < ActiveRecord::Migration
  def change
    add_column :essay_posts, :number_views, :integer, :default => 0
  end
end
