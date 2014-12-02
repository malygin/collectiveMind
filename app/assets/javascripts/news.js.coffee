@notificate_news = ->
  if document.location.pathname.match('general_news')
    ws = Websockets.connection()

    private_channel = ws.subscribe_private('news')
    private_channel.on_success = ->
      console.log("Has joined the channel")
    private_channel.on_failure = ->
      console.log("Authorization failed")
    private_channel.bind 'latest_news', (data) ->
      $('.feed .wrapper .feed-item:first').before(data)
