@comments_feed = ->



  this.edit_comment = (e)->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    stage = path.split('/')[0]
    form = $('<form accept-charset="UTF-8" action="/project/' + project + '/' + path + '/' + id + '/update_comment" data-remote="true" enctype="multipart/form-data" id="form_edit_comment_' + id + '" method="post"/>')
    form.append('<textarea class="form-control input-transparent comment-textarea" name="content" placeholder="Ваш комментарий" >' + $.trim($('#comment_text_' + id).html()) + '</textarea>')
    form.append('<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"></div>')
    form.append('<input id="' + stage + '_comment_image" name="image" type="file"><br/>')
    form.append('<button class="edit-cancel btn btn-xs btn-danger" data-id="' + id + '">Отменить</button> | ')
    form.append('<input class="btn btn-xs btn-info send-comment"  name="commit"  type="submit" value="Отправить">')
    $('#comment_text_' + id).html(form)
    $('#redactor_comment_' + id).fadeOut()

  this.edit_cancel = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    $('#comment_text_' + id).html($('#form_edit_comment_' + id + ' textarea').val())
    $('#form_edit_comment_' + id).fadeOut().remove()
    $('#comment_text_' + id).html()
    $('#redactor_comment_' + id).fadeIn()

  this.cancel_reply = (e) ->
    $(this).closest('form').animate
      height: 0, opacity: 0, 500, ->
        $(this).empty()
        $(this).css(opacity: 1, height: '')
    $('#reply_comment_' + $(this).data('id')).fadeIn()

  this.reply_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    stage = path.split('/')[0]
    form = $('#form_reply_comment_' + id)
    form.append('<br/><textarea class="form-control input-transparent comment-textarea"  name="' + stage + '_comment[content]" placeholder="Ваш комментарий или вопрос" ></textarea>')
    form.append('<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"></div>')
    form.append('<div class="pull-right">
                                          <div class="btn-group" data-toggle="buttons" id="change_comment_stat">
                                            <label class="btn btn-sm btn-default comment-problem">
                                              <input name="' + stage + '_comment[discontent_status]" type="hidden" value="0"><input id="' + stage + '_comment_discontent_status" name="' + stage + '_comment[discontent_status]" type="checkbox" value="1">
                                              Проблема
                                            </label>
                                            <label class="btn btn-sm btn-default comment-idea">
                                              <input name="' + stage + '_comment[concept_status]" type="hidden" value="0"><input id="' + stage + '_comment_concept_status" name="' + stage + '_comment[concept_status]" type="checkbox" value="1">
                                              Идея
                                            </label>
                                          </div>
                                          <button class="btn btn-danger btn-sm cancel-reply" data-id="' + id + '" type="button">Отмена</button>
                                          <input class="btn btn-sm btn-info send-comment disabled" id="send_comment" iname="commit" type="submit" value="Отправить">
                                        </div> <br/>')
    form.hide().fadeIn()
    $('#reply_comment_' + id).fadeOut()

  this.activate_button = ->
    form = $(this).closest('form');
    sendButton = form.find('.send-comment')
    if (this.value? and this.value.length > 1)
      sendButton.removeClass('disabled')
    else
      sendButton.addClass('disabled')

  this.color_for_idea = ->
    $(this).closest('form').find('.comment-idea').toggleClass('btn-warning')

  this.color_for_problem = ->
    $(this).closest('form').find('.comment-problem').toggleClass('btn-danger')

  this.toggle_discuss = ->
    $(this).toggleClass('label-default label-danger')

  this.toggle_approve = ->
    $(this).toggleClass('label-default label-success')

  $('.chat-messages').on('click', 'button.edit-comment', this.edit_comment)
  $('.chat-messages').on('click', 'button.edit-cancel', this.edit_cancel)
  $('.chat-messages').on('click', 'button.reply-comment', this.reply_comment)
  $('.chat-messages').on('click', 'button.cancel-reply', this.cancel_reply)

  $('.form-new-comment,.chat-messages').on('keyup', 'textarea.comment-textarea', this.activate_button)
  $('.form-new-comment,.chat-messages').on('click', 'label.comment-problem', this.color_for_problem)
  $('.form-new-comment,.chat-messages').on('click', 'label.comment-idea', this.color_for_idea)

  $('a.link_status').on('click', 'span.label_discuss', this.toggle_discuss)
  $('a.link_status').on('click', 'span.label_approve', this.toggle_approve)

  #  check if url contain anchor
  myLink = document.location.toString();
  if (myLink.match(/comment_(\d+)/))
    $('#comment_content_' + myLink.match(/comment_(\d+)/)[1]).effect("highlight", 3000);
    return false;