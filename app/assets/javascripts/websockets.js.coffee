class @Websockets
  instance = null

  @connection: ->
    #if not instance?
      #instance = new WebSocketRails(document.location.host + '/websocket')
      #instance.on_open = ->
      #  console.log 'websocket opened'
      #instance.on_failure = ->
      #  console.log 'websocket open error'

    instance
