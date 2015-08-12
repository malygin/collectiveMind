$pubnub = Pubnub.new(
    publish_key: ENV['PUBNUB_PUBLISH_KEY'].to_s || 'demo',
    subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'].to_s || 'demo'
)

Rails.logger.info "hello, it's #{ENV['PUBNUB_SUBSCRIBE_KEY']}"

# $pubnub = Pubnub.new(
#     publish_key: ENV['PUBNUB_PUBLISH_KEY'].to_s || 'demo',
#     subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'].to_s || 'demo'
# )
