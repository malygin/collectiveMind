class AddChatToUser < ActiveRecord::Migration
  def change
    add_column :users, :chat_open, :boolean, default: false
  end
end
