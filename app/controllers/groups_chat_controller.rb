class GroupsChatController < WebsocketRails::BaseController
  before_action :set_group, only: [:incoming_message, :send_history, :load_history]
  before_action :user_looked_at_chat, only: [:incoming_message, :send_history, :load_history]

  def initialize_session
  end

  def user_connected
    send_message :user_info, {user: 'current_user.firstname'}
  end

  def incoming_message
    group_message = current_user.group_chat_messages.create content: message[:text], group_id: @group.id
    @group.users.each do |user|
      WebsocketRails.users[user.id].send_message(:groups_new_message, group_message.to_json, channel: :group_chat)
    end
  end

  def send_history
    WebsocketRails.users[current_user.id].send_message(:groups_receive_history,
                                                       @group.chat_messages.history(message[:latest_id].to_i),
                                                       channel: :group_chat)
  end

  def load_history
    WebsocketRails.users[current_user.id].send_message(:groups_receive_history,
                                                       @group.chat_messages.recent.collect { |message| message.to_json },
                                                       channel: :group_chat)
  end

  def user_disconnected
    p 'user disconnected'
  end

  def authorize_channels
    if current_user.admin?
      accept_channel
    else
      deny_channel
    end
  end

  private
  def user_looked_at_chat
    current_user.group_users.by_group(@group).update_attributes! last_seen_chat_at: Time.now
  end

  def set_group
    @group = Group.find message[:group_id].to_i
  end
end
