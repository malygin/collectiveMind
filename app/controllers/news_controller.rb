class NewsController < WebsocketRails::BaseController
  def broadcast_news
    broadcast_message :latest_news, {news: message}
  end

  def authorize_channels
    if current_user?
      accept_channel
    else
      deny_channel
    end
  end
end
