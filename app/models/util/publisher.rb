class Util::Publisher
  def self.publisher(message, channel)
    Pub.nub.publish(message: message, channel: channel,
                    callback: ->(envelope) { puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end
