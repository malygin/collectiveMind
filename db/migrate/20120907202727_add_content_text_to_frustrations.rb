class AddContentTextToFrustrations < ActiveRecord::Migration
  def change
  	add_column :frustrations, :content_text, :string
  	add_column :frustrations, :old_content_text, :string
  end
end
