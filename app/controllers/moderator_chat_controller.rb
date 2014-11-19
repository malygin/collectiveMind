class ModeratorChatController < WebsocketRails::BaseController
  def initialize_session
  end

  def user_connected
  end

  def incoming_message
    moderator_message = current_user.moderator_messages.create message: message[:text]
    broadcast_message :new_message, {user: "#{current_user.name} #{current_user.surname}",
                                     avatar: current_user.avatar(:thumb), text: moderator_message.message,
                                     id: moderator_message.id,
                                     time: moderator_message.time}
  end

  def send_history
    current_user.looked_chat
    if message.nil?
      latest_id = ModeratorMessage.last.id
    else
      latest_id = message[:latest_id].to_i
    end

    WebsocketRails.users[current_user.id].send_message(:receive_history,
                                                       ModeratorMessage.history(latest_id),
                                                       channel: :moderator_chat)
  end

  def looked_chat
    current_user.looked_chat
  end

  def close_chat
    current_user.looked_chat
    current_user.update_attributes! chat_open: false
  end

  def minus_chat
    current_user.looked_chat
    current_user.update_attributes! chat_open: message[:status]
  end

  def user_disconnected
  end

  def authorize_channels
    if current_user.admin?
      accept_channel
    else
      deny_channel
    end
  end
end
