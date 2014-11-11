class GroupsChatController < WebsocketRails::BaseController
  def initialize_session
  end

  def user_connected
    send_message :user_info, {user: 'current_user.firstname'}
  end

  def incoming_message
    group = Group.find message[:group_id]
    group_message = current_user.group_chat_messages.create content: message[:text], group_id: group.id
    group.users.each do |user|
      WebsocketRails.users[user.id].send_message(:groups_new_message, group_message.to_json, channel: :group_chat)
    end
  end

  def send_history
    if message.nil? or message[:latest_id].nil?
      latest_id = GroupChatMessage.last.id
    else
      latest_id = message[:latest_id].to_i
    end

    WebsocketRails.users[current_user.id].send_message(:groups_receive_history,
                                                       GroupChatMessage.history(latest_id),
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
end
