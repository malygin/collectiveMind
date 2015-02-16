class AddCensoredToEstimate < ActiveRecord::Migration
  def change
    add_column :estimate_posts, :censored, :boolean,  :default => false
    add_column :estimate_comments, :censored, :boolean,  :default => false
  end
end
