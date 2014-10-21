class AddLastSeenNewsToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_seen_news, :timestamp
  end
end
