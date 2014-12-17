@create_moderator_chat = ->
  if $('#moderator_chat_div').length > 0
    unless (typeof Websockets == 'function')
      return
    ws = Websockets.connection()

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
        $('#last_seen_at').text(new Date())
        return
    )
    $('#old_title_page').text($('title').text().trim())
    ws.trigger 'get_history'
    if $('div#chat_opened').length <= 0
      $('span.ui-icon-minusthick').parent().click()

    ws.bind 'new_message', (data) ->
      $("#moderator_chat_div").chatbox("option", "boxManager").addMsg data
      if $('#current_user_name').text().trim() != data['user'].trim()
        $('#audio_new_message audio').trigger('play')
        $('title').text('У вас новое сообщение')
      if $('div.ui-widget-content.ui-chatbox-content').is(':hidden')
        Messenger.options =
          extraClasses: "messenger-fixed messenger-on-top messenger-on-right messenger-theme-air"
        msg = Messenger().post
          extraClasses: "messenger-fixed messenger-on-top  messenger-on-right messenger-theme-air"
          message: data['text']
          hideAfter: 3
      else
        $('#last_seen_at').text(new Date())
        ws.trigger 'looked_chat'

    private_channel.bind 'receive_history', (data) ->
      first_messages = false
      if $('#moderator_chat_div .ui-chatbox-msg').length == 0
        first_messages = true
      $.each data, (index, value) ->
        $("#moderator_chat_div").chatbox("option", "boxManager").addMsg value, false, false, false
      $("a#load_more_messages").remove()
      $("#moderator_chat_div").prepend "<a href='#' id='load_more_messages'>Загрузить еще</a>"
      $("a#load_more_messages").click ->
        ws.trigger 'get_history', {latest_id: $('#moderator_chat_div .ui-chatbox-msg').attr('id')}
      if first_messages
        $("#moderator_chat_div").chatbox("option", "boxManager")._scrollToBottom();
      $('#last_seen_at').text(new Date())

    $('span.ui-icon-closethick').parent().click ->
      ws.trigger 'close_chat'
      ws.disconnect()
      return
    $('span.ui-icon-minusthick').parent().click ->
      if $('div.ui-widget-content.ui-chatbox-content').is(':hidden')
        ws.trigger 'minus_chat', {status: false}
        $('#last_seen_at').text(new Date())
      else
        ws.trigger 'minus_chat', {status: true}
        $('#last_seen_at').text(new Date())
      return
    return
