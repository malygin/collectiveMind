class AddProjectToFrustrations < ActiveRecord::Migration
  def change
  	add_column :frustrations, :project_id, :integer, :default => 1
  end
end
