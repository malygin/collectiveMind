class AddPreviewForTests < ActiveRecord::Migration
  def change
  	add_column :tests, :preview, :text
  end
end
