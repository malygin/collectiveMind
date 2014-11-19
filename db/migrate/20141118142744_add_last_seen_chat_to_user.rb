class AddLastSeenChatToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_seen_chat_at, :datetime
  end
end
