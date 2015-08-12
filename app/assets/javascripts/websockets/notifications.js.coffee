@notifications = ->
  if $('#current_user_id').length > 0
    user_id = $('#current_user_id').text().trim()
    channel_name = 'notifications_' + user_id
  if channel_name and document.location.pathname.match('project')
    pubnub.subscribe
      channel: channel_name
      message: (data) ->
        journal_count = $('#my_journals_count')
        journal_count.addClass('top-circle').html((parseInt(journal_count.html()) || 0) + 1)
        journal_count.effect("bounce", "slow")
        journal_post = JST['templates/notification_message'](data)
        $('#dd_2 .ps_cont').append(journal_post)

        Messenger.options =
          extraClasses: "messenger-fixed messenger-on-top messenger-on-right messenger-theme-air"
        msg = Messenger().post
          extraClasses: "messenger-fixed messenger-on-top  messenger-on-right messenger-theme-air"
          message: "Обратите внимание! У вас есть непрочитанные уведомления. <br>"
          type: "error"
          showCloseButton: true
          actions:
            cancel:
              label: 'Просмотреть'
              action: ->
                msg.hide()
                $('#clear_my_journals').click()

