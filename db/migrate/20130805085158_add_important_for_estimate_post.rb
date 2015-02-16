class AddImportantForEstimatePost < ActiveRecord::Migration
  def change
      add_column :estimate_posts, :imp, :integer
  end
end
