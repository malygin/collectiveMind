class AddExpertContentToFrustrations < ActiveRecord::Migration
  def change
  	add_column :frustrations, :what_expert, :string
  	add_column :frustrations, :wherin_expert, :string
  	add_column :frustrations, :when_expert, :string
  end
end
