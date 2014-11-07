addMsg = (data, highlight = true, append = true, scroll = true) ->
  peer = data['user']
  msg = data['text']
  time = data['time']
  id = data['id']

  self = $("#moderator_chat_div").chatbox("option", "boxManager")
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
    ws.trigger 'get_history'
    if $('div#chat_opened').length <= 0
      $('span.ui-icon-minusthick').parent().click()

    ws.bind 'new_message', (data) ->
      addMsg data
      if $('div.ui-widget-content.ui-chatbox-content').is(':hidden')
        Messenger.options =
          extraClasses: "messenger-fixed messenger-on-top messenger-on-right messenger-theme-air"
        msg = Messenger().post
          extraClasses: "messenger-fixed messenger-on-top  messenger-on-right messenger-theme-air"
          message: data['text']
          hideAfter: 1

    private_channel.bind 'receive_history', (data) ->
      $.each data, (index, value) ->
        addMsg value, false, false, false
      $("a#load_more_messages").remove()
      $("#moderator_chat_div").prepend "<a href='#' id='load_more_messages'>Загрузить еще</a>"
      $("a#load_more_messages").click ->
        ws.trigger 'get_history', {latest_id: $('.ui-chatbox-msg').attr('id')}
    $('span.ui-icon-closethick').parent().click ->
      $('a#close_moderator_chat').click()
    $('span.ui-icon-minusthick').parent().click ->
      $('a#hide_moderator_chat').click()
