class FixSizeContentGroupChatMessage < ActiveRecord::Migration
  def change
    change_column :group_chat_messages, :content, :text
  end
end
