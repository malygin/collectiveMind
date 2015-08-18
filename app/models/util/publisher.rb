class Util::Publisher
  # метод для отправки сообщения в канал
  def self.publisher(message, channel)
    # определяем количество пользователей в канале и если оно больше нуля, то отправляем сообщение в pubnub
    Pub.nub.here_now(
      channel: channel
    ) do |envelope|
      puts envelope.parsed_response['uuids']
      puts envelope.parsed_response['occupancy']
      publish_message(message, channel) if envelope.parsed_response['occupancy'].try(:to_i) > 0
    end
  end

  def self.publish_message(message, channel)
    Pub.nub.publish(message: message, channel: channel,
                    callback: ->(envelope) { puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end
