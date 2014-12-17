@editable_groups = ->
  this.edit_task = (e)->
    e.preventDefault()
    modal_form = $('#createTask').clone().attr('id', 'editTask')
    $(modal_form).find('#createTaskLabel').text('Редактирование задачи')
    id_task = $(this).attr('id').replace(/^\D+/g, '')
    form = $(modal_form).find('form')
    form.attr('action', form.attr('action').replace('group_tasks', 'group_tasks/' + id_task))
    form.find('div:hidden:first').append('<input name="_method" type="hidden" value="patch">')
    form.find('#group_task_name').val($("#task_name_" + id_task).text().trim())
    form.find('#group_task_description').text($("#task_description_" + id_task).text().trim())
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
  input_file = $('form#group_send_file input#file')
  $('form#group_send_file').bind 'ajax:complete', ->
    input_file.replaceWith(input_file = input_file.clone(true));
  input_file.change ->
    $('form#group_send_file').submit()
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
    $(message).find('.chat-message-body .text').append($.parseHTML(data['text'])[0])
    lastSeenTime = new Date($('.last_seen_chat_at').text().trim())
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
    unless (typeof Websockets == 'function')
      return
    ws = Websockets.connection()

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

    private_channel.bind 'user_start_edit', (data) ->
      data = $.parseJSON(data)
      info_edit = $('#editing_models').clone().attr('id', 'editing_models_' + data.model.id)
      $(info_edit).text(data.model.name)
      $("#users_in_group_" + data.user.id).append(info_edit)
      console.log(data)

@group_actions = ->
  this.prepare_to_edit = (e) ->
    e.preventDefault()
    model_with_id = $(this).attr('id').replace('edit_', '')
    id = model_with_id.replace(/^\D+/g, '')
    model = model_with_id.replace(/[0-9]/g, '').replace('_', '/')
    model = model.substring(0, model.length - 1)
    $(document).ajaxComplete ->
      start_edit model, id

  this.stop_edit = (e) ->
    e.preventDefault()
    form = $(this).closest('form')
    unless form.length > 0
      form = $(this).closest('div.modal-content').find('form')
    form_id = form.attr('id')
    model_id = form_id.replace(/^\D+/g, '')
    model_name = form_id.replace('edit_', '').replace(/[0-9]/g, '').replace('_', '/')
    model_name = model_name.substring(0, model_name.length - 1)
    ws.trigger 'group.stop_edit', {model_id: model_id, model_name: model_name}

  this.start_edit = (model_name, model_id) ->
    ws.trigger 'group.start_edit', {
      model_name: model_name,
      model_id: model_id
    }

  if $('#edit_plan_post_model').length > 0
    unless (typeof Websockets == 'function')
      return
    ws = Websockets.connection()
    private_channel = ws.subscribe_private('group.actions')
    private_channel.on_success = ->
      console.log("Has joined the channel group actions")
    private_channel.on_failure = ->
      console.log("Authorization failed on group actions")
    private_channel.bind 'already_editing', (data) ->
      $("form[id*='" + data['model_name'].replace('/',
        '_') + "'][id*='" + data['model_id'] + "'] :input").prop('disabled', true)
      console.log(data)

    start_edit 'plan/post', $('#edit_plan_post_model').find('form').attr('id').replace(/^\D+/g, '')

    $("a[id*='edit']").on('click', this.prepare_to_edit)
    $("#modal_stage").on('click', "button[data-dismiss='modal']", this.stop_edit)
    $("#modal_stage").on('click', "input[type='submit']", this.stop_edit)
    return
