WebsocketRails::EventMap.describe do
  namespace :websocket_rails do
    subscribe :subscribe_private, to: ModeratorChatController, with_method: :authorize_channels
    subscribe :subscribe_private, to: NewsController, with_method: :authorize_channels
  end

  private_channel :news
  subscribe :latest_news, to: NewsController, with_method: :broadcast_news

  private_channel :moderator_chat
  subscribe :client_connected, to: ModeratorChatController, with_method: :user_connected
  subscribe :incoming_message, to: ModeratorChatController, with_method: :incoming_message
end
