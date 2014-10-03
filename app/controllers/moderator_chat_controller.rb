class ModeratorChatController < WebsocketRails::BaseController
  before_filter :set_current_user

  def initialize_session
  end

  def user_connected
    p 'user connected'
    send_message :user_info, {user: 'current_user.firstname'}
  end

  def incoming_message
    # moderator_message = @current_user.moderator_messages.create message: message[:text]
    # broadcast_message :new_message, {user: "#{@current_user.name} #{@current_user.surname}",
    #                                  avatar: @current_user.avatar(:thumb), text: moderator_message.message,
    #                                  id: moderator_message.id,
    #                                  time: Russian::strftime(moderator_message.created_at, '%k:%M:%S')}
    broadcast_message :new_message, {text: message[:text], id: (1 + Random.rand(9999))}
  end

  def user_disconnected
    p 'user disconnected'
  end

  def authorize_channels
    session.inspect
    if true
      accept_channel
    else
      deny_channel
    end
  end

  private
  def set_current_user
    @current_user = warden.authenticate
  end
end
