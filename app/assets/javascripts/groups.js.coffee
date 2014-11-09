addMsg = (data, highlight = true, append = true, scroll = true) ->
  peer = data['user']
  msg = data['text']
  time = data['time']
  id = data['id']

  self = $("#group_chat_div").chatbox("option", "boxManager")
  box = self.elem.uiChatboxLog
  e = document.createElement("div")
  $(e).attr('id', id)

  if append
    box.append e
  else
    box.prepend e
  $(e).hide()

  systemMessage = false
  if peer
    timeText = document.createElement('div')
    $(timeText).addClass('time pull-left').text time
    peerName = document.createElement("b")
    $(peerName).text peer + ": "
    e.appendChild timeText
    e.appendChild peerName
  else
    systemMessage = true
  msgElement = document.createElement((if systemMessage then "i" else "span"))
  $(msgElement).text msg
  e.appendChild msgElement
  $(e).addClass "ui-chatbox-msg"
  $(e).css "maxWidth", $(box).width()
  $(e).fadeIn()

  if scroll
    self._scrollToBottom()
  if not self.elem.uiChatboxTitlebar.hasClass("ui-state-focus") and not self.highlightLock and highlight
    self.highlightLock = true
    self.highlightBox()
  return

@create_group_chat = ->
  if $('#group_chat_div').length > 0
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
      addMsg data
    private_channel.bind 'groups_receive_history', (data) ->
      first_messages = false
      if $('#group_chat_div .ui-chatbox-msg').length == 0
        first_messages = true
      $.each data, (index, value) ->
        addMsg value, false, false, false
      $("a#groups_load_more_messages").remove()
      $("#group_chat_div").prepend "<a href='#' id='groups_load_more_messages'>Загрузить еще</a>"
      $("a#groups_load_more_messages").click ->
        ws.trigger 'groups_get_history', {latest_id: $('#group_chat_div .ui-chatbox-msg').attr('id'), group_id: $('.id_group').attr('id')}
      if first_messages
        $("#group_chat_div").chatbox("option", "boxManager")._scrollToBottom();
