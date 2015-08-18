# class WebsocketNotification
#   @queue = :websocket_notification
#
#   # def self.perform(users, event, channel, id_message)
#   #   data = GroupChatMessage.find id_message
#   #   Rails.logger.info '=======================users'
#   #   Rails.logger.info users
#   #   Rails.logger.info '=======================event'
#   #   Rails.logger.info event
#   #   Rails.logger.info '=======================data'
#   #   Rails.logger.info data
#   #   Rails.logger.info '=======================channel'
#   #   Rails.logger.info channel
#   #   begin
#   #     users.each do |user|
#   #       WebsocketRails.users[user.to_i].send_message(event.to_sym, data.to_json, channel: channel.to_sym)
#   #     end
#   #   rescue  => e
#   #     Rails.logger.info e.message
#   #     Rails.logger.info e.backtrace.inspect
#   #   end
#   # end
# end
