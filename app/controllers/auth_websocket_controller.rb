class AuthWebsocketController < WebsocketRails::BaseController
  def authorize_channels
    channel = message[:channel]
    case channel
      when 'moderator_chat'
        auth_moderator
      when 'news', 'notifications', 'group.actions'
        auth_user
      when 'group_chat'
        auth_group_user
      else
        deny_channel
    end
  end

  private
  def auth_user
    if current_user.nil?
      deny_channel
    else
      accept_channel current_user
    end
  end

  def auth_moderator
    if current_user.admin?
      accept_channel current_user
    else
      deny_channel
    end
  end

  def auth_group_user
    #@todo tmp
    auth_user
  end
end
