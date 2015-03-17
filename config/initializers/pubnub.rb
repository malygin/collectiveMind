$pubnub = Pubnub.new(
    publish_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
    subscribe_key: ENV['PUBNUB_PUBLISH_KEY']
)
