class AddProjectToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :project_id, :integer
    add_index :discontent_posts, :project_id
  end
end
