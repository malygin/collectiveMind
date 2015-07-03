# WebsocketRails::EventMap.describe do
#   namespace :websocket_rails do
#     subscribe :subscribe_private, to: AuthWebsocketController, with_method: :authorize_channels
#   end
#
#   private_channel :news
#   private_channel :notifications
#
#   private_channel :visits
#   subscribe :client_disconnected, to: RecordVisitController, with_method: :stop_visit
#
# end
