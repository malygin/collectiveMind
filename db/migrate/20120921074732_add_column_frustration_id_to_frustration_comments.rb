class AddColumnFrustrationIdToFrustrationComments < ActiveRecord::Migration
  def change
  	add_column :frustration_comments, :frustration_comment_id, :integer
  end
end
