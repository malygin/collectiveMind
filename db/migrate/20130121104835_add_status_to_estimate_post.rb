class AddStatusToEstimatePost < ActiveRecord::Migration
  def change
  	  add_column :estimate_posts, :status, :integer
  	  add_index :estimate_posts,:status
  end
end
