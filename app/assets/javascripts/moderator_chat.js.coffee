$(document).ready ->
  ws = new WebSocketRails(document.location.hostname + ':3001/websocket')
  ws.on_open = ->
    console.log 'socket opened'

  private_channel = ws.subscribe_private('moderator_chat')
  private_channel.on_success = ->
    console.log("Has joined the channel")
  private_channel.on_failure = ->
    console.log("Authorization failed")

  ws.bind 'new_message', (data) ->
    console.log data
    new_message = $('#template_base_sent').clone().prop({id: 'message_' + data['id']});
    new_message.find('.msg_sent p').append(data['text']);
    new_message.find('.msg_sent time').append(data['user'] + ' • ' + data['time']);
    new_message.find('.avatar img').attr('src', data['avatar']);
    $('#chat_history').append(new_message.show())
    $('#chat_history').animate({"scrollTop":$('#chat_history .msg_container:last').height()}, 'slow');

  $('#btn-chat').on 'click', ->
    ws.trigger 'incoming_message', {text: $('#btn-input').val()}
    $('#btn-input').val('')

$(document).on "click", ".panel-heading span.icon_minim", (e) ->
  $this = $(this)
  unless $this.hasClass("panel-collapsed")
    $this.parents(".panel").find(".panel-body").slideUp()
    $this.addClass "panel-collapsed"
    $this.removeClass("glyphicon-minus").addClass "glyphicon-plus"
  else
    $this.parents(".panel").find(".panel-body").slideDown()
    $this.removeClass "panel-collapsed"
    $this.removeClass("glyphicon-plus").addClass "glyphicon-minus"
  return

$(document).on "focus", ".panel-footer input.chat_input", (e) ->
  $this = $(this)
  if $("#minim_chat_window").hasClass("panel-collapsed")
    $this.parents(".panel").find(".panel-body").slideDown()
    $("#minim_chat_window").removeClass "panel-collapsed"
    $("#minim_chat_window").removeClass("glyphicon-plus").addClass "glyphicon-minus"
  return

$(document).on "click", ".icon_close", (e) ->

  #$(this).parent().parent().parent().parent().remove();
  $("#chat_window_1").remove()
  return
