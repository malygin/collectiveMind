class AddContentTextToFrustrations < ActiveRecord::Migration
  def change
  	add_column :frustrations, :content_text, :string
  	add_column :frustrations, :content_text_old, :string
  end
end
