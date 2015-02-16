class AddNumberViewsEstimatePost < ActiveRecord::Migration
  def change
    add_column :estimate_posts, :number_views, :integer, :default => 0

  end
end
