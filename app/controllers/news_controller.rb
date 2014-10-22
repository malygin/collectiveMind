class NewsController < WebsocketRails::BaseController
  def broadcast_news
    broadcast_message :latest_news, {news: message}
  end

  def authorize_channels
    if current_user.nil?
      deny_channel
    else
      accept_channel current_user
    end
  end
end
