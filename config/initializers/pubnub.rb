# подгрузка модуля для хранения переменной пабнаба (не в глобальной)
Dir["#{Rails.root}/app/models/util/pubnub.rb"].each { |file| require file }
Pub.nub = Pubnub.new(
    publish_key: ENV['PUBNUB_PUBLISH_KEY'].present? ? ENV['PUBNUB_PUBLISH_KEY'] : 'demo',
    subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'].present? ? ENV['PUBNUB_SUBSCRIBE_KEY'] : 'demo'
)


