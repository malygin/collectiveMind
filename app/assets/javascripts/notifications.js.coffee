@notificate_my_journals = ->
  if $("#set_notification_message").length > 0
    Messenger.options = extraClasses: "messenger-fixed messenger-on-top"
    Messenger().post
      extraClasses: "messenger-fixed messenger-on-top"
      message: "Обратите внимание! У вас есть непрочитанные уведомления"
      type: "error"
      showCloseButton: true

  return
