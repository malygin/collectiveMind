WebsocketRails::EventMap.describe do
  namespace :websocket_rails do
    subscribe :subscribe_private, to: AuthWebsocketController, with_method: :authorize_channels
  end

  private_channel :news
  private_channel :notifications

  private_channel :moderator_chat
  subscribe :incoming_message, to: ModeratorChatController, with_method: :incoming_message
  subscribe :get_history, to: ModeratorChatController, with_method: :send_history
  subscribe :looked_chat, to: ModeratorChatController, with_method: :looked_chat
  subscribe :close_chat, to: ModeratorChatController, with_method: :close_chat
  subscribe :minus_chat, to: ModeratorChatController, with_method: :minus_chat

  private_channel :group_chat
  subscribe :groups_incoming_message, to: GroupsChatController, with_method: :incoming_message
  subscribe :groups_get_history, to: GroupsChatController, with_method: :send_history
  subscribe :groups_load_history, to: GroupsChatController, with_method: :load_history

  namespace :group do
    private_channel :actions
    subscribe :start_edit, to: GroupActionsController, with_method: :start_edit
  end
  subscribe :client_disconnected, to: GroupActionsController, with_method: :client_disconnected
end
