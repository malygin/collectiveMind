@notificate_my_journals = ->
  if $("#set_notification_message").length > 0
    Messenger.options =
      extraClasses: "messenger-fixed messenger-on-top"
    msg = Messenger().post
      extraClasses: "messenger-fixed messenger-on-top"
      message: "Обратите внимание! У вас есть непрочитанные уведомления. <br>"
      type: "error"
      showCloseButton: true
      actions:
        cancel:
          label: 'Просмотреть'
          action: ->
            msg.hide()
            $('#messages').click()

  return

$(document).ready ->
  if document.location.pathname.match('project')
    ws = new WebSocketRails(document.location.host + '/websocket')
    ws.on_open = ->
      console.log 'socket opened'
    ws.on_failure = ->
      console.log 'socket open error'

    private_channel = ws.subscribe_private('notifications')
    private_channel.on_success = ->
      console.log("Has joined the channel notifications")
    private_channel.on_failure = ->
      console.log("Authorization failed channel notifications")
    private_channel.bind 'latest', (data) ->
      $('#notifications').html(data);
      $(".count").effect("bounce", "slow")
