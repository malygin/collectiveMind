class ModeratorChatController < WebsocketRails::BaseController
  def initialize_session
  end

  def user_connected
    send_message :user_info, {user: 'current_user.firstname'}
  end

  def incoming_message
    moderator_message = current_user.moderator_messages.create message: message[:text]
    broadcast_message :new_message, {user: "#{current_user.name} #{current_user.surname}",
                                     avatar: current_user.avatar(:thumb), text: moderator_message.message,
                                     id: moderator_message.id,
                                     time: moderator_message.time}
  end

  def send_history
    if message.nil?
      latest_id = ModeratorMessage.last.id
    else
      latest_id = message[:latest_id].to_i
    end

    WebsocketRails.users[current_user.id].send_message(:receive_history,
                                                       ModeratorMessage.history(latest_id),
                                                       channel: :moderator_chat)
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
