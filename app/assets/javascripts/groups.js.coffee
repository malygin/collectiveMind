@editable_groups = ->
  this.edit_task = (e)->
    e.preventDefault()
    modal_form = $('#createTask').clone().attr('id', 'editTask')
    $(modal_form).find('#createTaskLabel').text('Редактирование задачи')
    id_task = $(this).parent().attr('id').replace(/^\D+/g, '')
    form = $(modal_form).find('form')
    form.attr('action', form.attr('action').replace('group_tasks', 'group_tasks/' + id_task))
    form.find('div:hidden').append('<input name="_method" type="hidden" value="patch">')
    form.find('#group_task_name').val($(this).parent().find('.name').text().trim())
    form.find('#group_task_description').text($(this).parent().find('.description').text().trim())
    $(modal_form).modal('show')

  this.assign_user = (e)->
    e.preventDefault()
    id_task = $(this).parent().attr('id').replace(/^\D+/g, '')
    modal_form = $('#assignTaskToUser').clone().attr('id', 'assignTaskToUser' + id_task)
    $(modal_form).find('.link_to_assign').each ->
      $(this).find('a').attr('href', $(this).find('a').attr('href').replace('_group_task_id_', id_task))
    $(modal_form).modal('show')

  $('.group-tasks').on('click', 'button.edit-task', this.edit_task)
  $('.group-tasks').on('click', 'button.assign-user', this.assign_user)
  return

@create_group_chat = ->
  $("#chat-messages").slimscroll
    height: "290px"
    size: "5px"
    alwaysVisible: true
    railVisible: true

  if $('.group-chat#chat').length > 0 && $('.id_group').length > 0
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
    $('#send_message-btn').on 'click', ->
      ws.trigger 'groups_incoming_message', {text: $(this).parent().find('#new-message').val().trim(), group_id: $('.id_group').attr('id')}
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
