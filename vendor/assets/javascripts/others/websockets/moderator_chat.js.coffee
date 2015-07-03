@create_moderator_chat = ->
  channel_name = 'moderator_chat'
  if $('#moderator_chat_div').length > 0
    $("#moderator_chat_div").chatbox(
      id: "moderator_chat_div"
      user:
        key: ''
      title: "Задать вопрос модератору"
      messageSent: (id, user, msg) ->
        current_time = new Date()
        pubnub.publish({
          channel: channel_name, message: {
            text: msg,
            user: $('#current_user_name').text().trim(),
            time: current_time
          }
        })
        $('#last_seen_at').text(current_time)
        return
    )
    $('#old_title_page').text($('title').text().trim())
    pubnub.subscribe
      channel: channel_name
      message: (data) ->
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
        console.log data
        return
    pubnub.history
      channel: channel_name
      count: 5
      callback: (data) ->
        first_messages = false
        if $('#moderator_chat_div .ui-chatbox-msg').length == 0
          first_messages = true
        $.each data, (index, value) ->
          $("#moderator_chat_div").chatbox("option", "boxManager").addMsg value, false, false, false
        $("a#load_more_messages").remove()
        $("#moderator_chat_div").prepend "<a href='#' id='load_more_messages'>Загрузить еще</a>"
        #$("a#load_more_messages").click ->
        #ws.trigger 'get_history', {latest_id: $('#moderator_chat_div .ui-chatbox-msg').attr('id')}
        if first_messages
          $("#moderator_chat_div").chatbox("option", "boxManager")._scrollToBottom();
        $('#last_seen_at').text(new Date())
        console.log data
        return

    if $('div#chat_opened').length <= 0
      $('span.ui-icon-minusthick').parent().click()

    $('a.ui-close-chat').click ->
      pubnub.unsubscribe channel: channel_name
      return
    $('a.ui-minimize-chat').click ->
      $('#last_seen_at').text(new Date())
      return
    $('div.ui-chatbox-titlebar').click ->
      $('a.ui-minimize-chat').click()
    return
