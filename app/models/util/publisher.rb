class Util::Publisher
  def self.publisher(message, channel)
    $pubnub.publish(message: message, channel: channel,
                    callback: lambda { |envelope| puts("channel: #{envelope.channel}; msg: #{envelope.message}") })
  end
end
