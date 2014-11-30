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
  this.chat_div = $('#chat-messages.chat-messages')

  this.scrollToBottom = ->
    $(this.chat_div).slimscroll({scrollTo: $(this.chat_div).prop('scrollHeight') + 'px'});

  this.addMsg = (data, append = true) ->
    message = $('#template_chat_message').clone().attr('id', data['id'])
    $(message).find('.sender .icon').append("<img src=" + data['avatar'] + '>')
    $(message).find('.sender .time').text(data['time'])
    $(message).find('.chat-message-body .sender').text(data['user'])
    $(message).find('.chat-message-body .text').text(data['text'])
    lastSeenTime = new Date($('.last_seen_at').text().trim())
    time = new Date(data['created_at'])
    if time > lastSeenTime && $('.current_user_name').text().trim() != data['user'].trim()
      $(message).addClass('unreaded')
      $(message).mouseenter ->
        $(this).removeClass('unreaded')
    $(message).show()
    if append
      $(this.chat_div).append(message)
      scrollToBottom()
    else
      $(this.chat_div).prepend(message)

  this.sendMessage = (message_text) ->
    ws.trigger 'groups_incoming_message', {
      text: message_text,
      group_id: $('.id_group').attr('id')
    }
    $('input#new-message').val('')

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

    private_channel.bind 'groups_new_message', (data) ->
      addMsg(data)
    private_channel.bind 'groups_receive_history', (data) ->
      first_messages = false
      if $(this.chat_div).find('.chat-message').length == 0
        first_messages = true
      $.each data, (index, value) ->
        addMsg(value, false)
      if first_messages
        scrollToBottom()
      $("a#groups_load_more_messages").remove()
      $(this.chat_div).prepend "<a href='#' id='groups_load_more_messages'>Загрузить еще</a>"
      $("a#groups_load_more_messages").click ->
        ws.trigger 'groups_get_history', {
          latest_id: $(chat_div).find('.chat-message:first').attr('id'),
          group_id: $('.id_group').attr('id')
        }
    $('#send_message-btn').on 'click', ->
      sendMessage($(this).parent().parent().find('#new-message').val())
    $('input#new-message').bind 'keypress', (e) ->
      code = e.keyCode || e.which;
      if(code == 13)
        e.preventDefault();
        sendMessage($('input#new-message').val())
    $(this.chat_div).slimscroll
      height: "290px"
      size: "5px"
      alwaysVisible: true
      railVisible: true

    ws.trigger 'groups_load_history', {group_id: $('.id_group').attr('id')}
