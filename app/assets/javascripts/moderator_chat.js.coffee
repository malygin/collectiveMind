@create_moderator_chat = ->
  if document.location.pathname.match('project') && $('#moderator_chat_div').length > 0
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
    $("#moderator_chat_div").chatbox(
      id: "moderator_chat_div"
      user:
        key: ''
      title: "Модераторский чат"
      messageSent: (id, user, msg) ->
        ws.trigger 'incoming_message', {text: msg}
        return
    )
    $('#chat_log').children().each ->
      $("#moderator_chat_div").chatbox("option", "boxManager").addMsg($(this).find('b').text().trim(),
        $(this).find('span').text().trim())
    if $('a#open_moderator_chat').length > 0
      $('span.ui-icon-minusthick').parent().click()

    ws.bind 'new_message', (data) ->
      console.log(data)
      $("#moderator_chat_div").chatbox("option", "boxManager").addMsg data['user'], data['text']
      if $('div.ui-widget-content.ui-chatbox-content').is(':hidden')
        Messenger.options =
          extraClasses: "messenger-fixed messenger-on-top messenger-on-right messenger-theme-air"
        msg = Messenger().post
          extraClasses: "messenger-fixed messenger-on-top  messenger-on-right messenger-theme-air"
          message: data['text']
          hideAfter: 1
    $('span.ui-icon-closethick').parent().click ->
      $('a#close_moderator_chat').click()
    $('span.ui-icon-minusthick').parent().click ->
      $('a#open_moderator_chat').click()
