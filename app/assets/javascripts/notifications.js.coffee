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
