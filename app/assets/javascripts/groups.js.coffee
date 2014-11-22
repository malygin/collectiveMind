@create_group_chat = ->
  if false
    ws = new WebSocketRails(document.location.host + '/websocket')
    ws.on_open = ->
      console.log 'socket opened'
    ws.on_failure = ->
      console.log 'socket open error'

    private_channel = ws.subscribe_private('group_chat')
    private_channel.on_success = ->
      console.log("Has joined the channel group_chat")
    private_channel.on_failure = ->
      console.log("Authorization failed")
    $("#group_chat_div").chatbox(
      id: "group_chat_div"
      offset: 350
      user:
        key: ''
      title: "Чат группы"
      messageSent: (id, user, msg) ->
        ws.trigger 'groups_incoming_message', {text: msg, group_id: $('.id_group').attr('id')}
        return
    )
    ws.trigger 'groups_get_history', {group_id: $('.id_group').attr('id')}
    private_channel.bind 'groups_new_message', (data) ->
      $("#group_chat_div").chatbox("option", "boxManager") data
    private_channel.bind 'groups_receive_history', (data) ->
      first_messages = false
      if $('#group_chat_div .ui-chatbox-msg').length == 0
        first_messages = true
      $.each data, (index, value) ->
        $("#group_chat_div").chatbox("option", "boxManager") value, false, false, false
      $("a#groups_load_more_messages").remove()
      $("#group_chat_div").prepend "<a href='#' id='groups_load_more_messages'>Загрузить еще</a>"
      $("a#groups_load_more_messages").click ->
        ws.trigger 'groups_get_history', {latest_id: $('#group_chat_div .ui-chatbox-msg').attr('id'), group_id: $('.id_group').attr('id')}
      if first_messages
        $("#group_chat_div").chatbox("option", "boxManager")._scrollToBottom();
