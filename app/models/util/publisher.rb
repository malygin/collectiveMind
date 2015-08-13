class Util::Publisher
  # метод для отправки сообщения в канал
  def self.publisher(message, channel)
    Pub.nub.here_now(
        channel: channel
    ) do |envelope|
      puts envelope.parsed_response['uuids']
      puts envelope.parsed_response['occupancy']
      return if envelope.parsed_response['occupancy'].try(:to_i) <= 0
    end

    Pub.nub.publish(message: message, channel: channel,
                    callback: ->(envelope) { puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end
