class AddLastSeenChatToGroupUsers < ActiveRecord::Migration
  def change
    add_column :group_users, :last_seen_chat_at, :datetime
  end
end
