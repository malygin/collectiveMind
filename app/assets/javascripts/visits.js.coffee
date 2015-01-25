@record_visit = ->
  if document.location.pathname.match('project')
    unless (typeof Websockets == 'function')
      return
    ws = Websockets.connection()
    private_channel = ws.subscribe_private('visits')
    private_channel.on_success = ->
      console.log("Has joined the channel notifications")
    private_channel.on_failure = ->
      console.log("Authorization failed channel notifications")
    ws.trigger 'start_visit', {
      location: $(location)
    }
