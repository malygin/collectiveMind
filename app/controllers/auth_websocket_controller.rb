class AuthWebsocketController < WebsocketRails::BaseController
  def authorize_channels
    if current_user.nil?
      deny_channel
    else
      accept_channel current_user
    end
  end
end
