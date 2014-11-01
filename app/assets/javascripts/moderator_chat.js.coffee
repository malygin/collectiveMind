$(document).ready ->
  if document.location.pathname.match('project')
    ws = new WebSocketRails(document.location.host + '/websocket')
    ws.on_open = ->
      console.log 'socket opened'
    ws.on_failure = ->
      console.log 'socket open error'

    private_channel = ws.subscribe_private('moderator_chat')
    private_channel.on_success = ->
      console.log("Has joined the channel moderator chat")
    private_channel.on_failure = ->
      console.log("Authorization failed")

    ws.bind 'new_message', (data) ->
      console.log(data)
      $("#chat_div").chatbox("option", "boxManager").addMsg data['user'], data['text']
      Messenger.options =
        extraClasses: "messenger-fixed messenger-on-top messenger-on-right messenger-theme-air"
      msg = Messenger().post
        extraClasses: "messenger-fixed messenger-on-top  messenger-on-right messenger-theme-air"
        message: data['text']
        type: "error"
        showCloseButton: true

    box = null
    $("#open_moderator_chat").click (event, ui) ->
      if box
        box.chatbox("option", "boxManager").toggleBox()
      else
        box = $("#chat_div").chatbox(
          id: "chat_div"
          user:
            key: "value"
          title: "Модераторский чат"
          messageSent: (id, user, msg) ->
            ws.trigger 'incoming_message', {text: msg}
            #$("#chat_div").chatbox("option", "boxManager").addMsg id, msg
            return
        )
      return
    $('#chat_div').draggable()
