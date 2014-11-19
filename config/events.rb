WebsocketRails::EventMap.describe do
  namespace :websocket_rails do
    subscribe :subscribe_private, to: ModeratorChatController, with_method: :authorize_channels
    subscribe :subscribe_private, to: AuthWebsocketController, with_method: :authorize_channels
  end

  private_channel :news
  private_channel :notifications

  private_channel :moderator_chat
  subscribe :incoming_message, to: ModeratorChatController, with_method: :incoming_message
  subscribe :get_history, to: ModeratorChatController, with_method: :send_history

  # private_channel :group_chat
  # subscribe :groups_incoming_message, to: GroupsChatController, with_method: :incoming_message
  # subscribe :groups_get_history, to: GroupsChatController, with_method: :send_history
end
