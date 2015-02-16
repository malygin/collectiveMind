class AddColumnNumberViewsToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :number_views, :integer,  :default => 0
  end
end
