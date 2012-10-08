class AddUsefulNegativeCommentsToFrustrationComment < ActiveRecord::Migration
  def change
  	add_column :frustration_comments, :useful_frustration_id, :integer
  	add_index :frustration_comments, :useful_frustration_id
  end
end
