console.log($('.feed .wrapper .feed-item:first'))
$(document).ready ->
  ws = new WebSocketRails(document.location.hostname + ':3000/websocket')
  ws.on_open = ->
    console.log 'socket opened'
  ws.on_failure = ->
    console.log 'socket open error'

  private_channel = ws.subscribe_private('news')
  private_channel.on_success = ->
    console.log("Has joined the channel")
  private_channel.on_failure = ->
    console.log("Authorization failed")

  ws.trigger 'latest_news', {text: 'Test'}

  ws.bind 'latest_news', (data) ->
    console.log data
