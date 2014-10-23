$(document).ready ->
  if document.location.pathname.match('journals$|general_news')
    ws = new WebSocketRails(document.location.host + '/websocket')
    ws.on_open = ->
      console.log 'socket opened'
    ws.on_failure = ->
      console.log 'socket open error'

    private_channel = ws.subscribe_private('news')
    private_channel.on_success = ->
      console.log("Has joined the channel")
    private_channel.on_failure = ->
      console.log("Authorization failed")
    private_channel.bind 'latest_news', (data) ->
      $('.feed .wrapper .feed-item:first').before(data)
