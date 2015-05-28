$pubnub = Pubnub.new(
    publish_key: ENV['PUBNUB_SUBSCRIBE_KEY'].to_s || 'demo',
    subscribe_key: ENV['PUBNUB_PUBLISH_KEY'].to_s || 'demo'
)
