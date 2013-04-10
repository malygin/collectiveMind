class AddProjectIdToExpertNewsPost < ActiveRecord::Migration
  def change
    add_column :expert_news_posts, :project_id, :integer
    add_index :expert_news_posts, :project_id
  end
end
