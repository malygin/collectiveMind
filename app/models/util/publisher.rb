class Util::Publisher
  # метод для отправки сообщения в канал
  def self.publisher(message, channel)
    Pub.nub.publish(message: message, channel: channel,
                    callback: ->(envelope) { puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end
