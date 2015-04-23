@comments_feed = ->
  this.edit_comment = (e)->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
  #    stage = path.split('/')[0]
    stage = path.replace('/posts', '').replace('/', '_')
    form = $('<form class="form-group comment_add collapse" accept-charset="UTF-8" action="/project/' + project + '/' + path.replace('core/', '') + '/' + id + '/update_comment" data-remote="true" id="form_edit_comment_' + id + '" method="post"/>')
    form.append('<input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put">')
    form.append('<div class="input_cont"><textarea name="content" placeholder="Ваш комментарий" >' + $.trim($('#comment_text_' + id).html()) + '</textarea></div>')
    form.append('<button class="btn" type="submit"><span class="bold"><i class="fa fa-reply fa-rotate-180 theme_font_color"></i></span></button>')
  #    form.append('<input id="' + stage + '_comment_image" name="image" type="file"><br/>')
  #    form.append('<br/><br/><a class="edit-cancel btn btn-xs btn-danger" data-id="' + id + '">Отменить</a>')
  #    form.append('<input class="btn btn-xs btn-info send-comment"  name="commit"  type="submit" value="Отправить">')
    $('#comment_text_' + id).html(form)
    $('#cancel_comment_' + id).append('<a href="#" class="edit-cancel" style="display:none;" data-id="' + id + '"><span class="label label-danger">Отменить</span></a>')
    $('#redactor_comment_' + id).fadeOut()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeIn()
    $('#form_edit_comment_' + id).collapse('show')
    comments_sumbit()
    textarea_autosize()


  this.edit_cancel = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    $('#comment_text_' + id).html($('#form_edit_comment_' + id + ' textarea').val())
    $('#form_edit_comment_' + id).fadeOut().remove()
  #    $('#comment_text_' + id).html()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeOut()
    $('#redactor_comment_' + id).fadeIn()
    $('#cancel_comment_' + id).html('')

  this.cancel_reply = (e) ->
    e.preventDefault()
    $(this).closest('.media.comment').next('form').collapse('hide').remove()
    $(this).toggleClass('reply-comment cancel-reply')

  #    $(this).closest('form').animate
  #      height: 0, opacity: 0, 500, ->
  #        $(this).empty()
  #        $(this).css(opacity: 1, height: '')
  #    $('#reply_comment_' + $(this).data('id')).fadeIn()


  this.reply_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    comment = $(this).data('comment')
    #  stage = path.split('/')[0]
    stage = path.replace('/posts', '').replace('/', '_')
    form = $('<form class="form-group comment_add collapse" accept-charset="UTF-8" action="/project/' + project + '/' + path.replace('core/', '') + '/' + id + '/add_comment?comment=' + comment + '" data-remote="true" id="reply_form_' + comment + '" method="post"/>')
    form.append('<input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put">')
    form.append('<div class="input_cont"><textarea name="' + stage + '_comment[content]" placeholder="Ваш комментарий" ></textarea></div>')
    form.append('<button class="btn" type="submit"><span class="bold"><i class="fa fa-reply fa-rotate-180 theme_font_color"></i></span></button>')
    $('#comment' + comment).after(form)
    $('#reply_form_' + comment).collapse('show')
    $('#reply_comment_' + comment).toggleClass('reply-comment cancel-reply')
    comments_sumbit()
    textarea_autosize()

  #    form = $('#form_reply_comment_' + id)
  #    form.append('<br/><textarea class="form-control input-transparent comment-textarea"  name="' + stage + '_comment[content]" placeholder="Ваш комментарий или вопрос" ></textarea>')
  #    form.append('<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"></div>')
  #    form.append('<div class="pull-right">
  #                                          <div class="btn-group" data-toggle="buttons" id="change_comment_stat">
  #                                            <label class="btn btn-sm btn-default comment-problem">
  #                                              <input name="' + stage + '_comment[discontent_status]" type="hidden" value="0"><input id="' + stage + '_comment_discontent_status" name="' + stage + '_comment[discontent_status]" type="checkbox" value="1">
  #                                              Проблема
  #                                            </label>
  #                                            <label class="btn btn-sm btn-default comment-idea">
  #                                              <input name="' + stage + '_comment[concept_status]" type="hidden" value="0"><input id="' + stage + '_comment_concept_status" name="' + stage + '_comment[concept_status]" type="checkbox" value="1">
  #                                              Идея
  #                                            </label>
  #                                          </div>
  #                                          <button class="btn btn-danger btn-sm cancel-reply" data-id="' + id + '" type="button">Отмена</button>
  #                                          <input class="btn btn-sm btn-info send-comment disabled" id="send_comment" iname="commit" type="submit" value="Отправить">
  #                                        </div> <br/>')
  #    form.hide().fadeIn()
  #    $('#reply_comment_' + id).fadeOut()




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

  this.autosize = ->
    $(this).autosize()

  this.comments_collapse = ->
    col = $(this).attr('data-col')
    $('.popup_expandable_col').toggleClass('col-md-' + col).toggleClass('col-md-12').toggleClass 'exp'

  this.submit_enter = (e) ->
    if e.keyCode == 13
      $(this).closest('form').trigger 'submit'

  #  this.toggle_scores = ->
  #    $(this).toggleClass('label-danger label-success')
  #    text = $(this).text().trim()
  #    if text == 'Выдать баллы'
  #      $(this).html('Забрать баллы')
  #    else
  #      $(this).html('Выдать баллы')

  $('.chat-messages').on('click', 'a.edit-comment', this.edit_comment)
  $('.chat-messages').on('click', 'a.edit-cancel', this.edit_cancel)
  $('.chat-messages').on('click', 'button.reply-comment', this.reply_comment)
  $('.chat-messages').on('click', 'button.cancel-reply', this.cancel_reply)

  $('.form-new-comment,.chat-messages').on('keyup', 'textarea.comment-textarea', this.activate_button)
  #  $('#render_discontent_comments,#popup-innov').on('keyup', 'textarea.comment-textarea', this.activate_button)
  $('.form-new-comment,.chat-messages').on('click', 'label.comment-problem', this.color_for_problem)
  $('.form-new-comment,.chat-messages').on('click', 'label.comment-idea', this.color_for_idea)

  $('.chat-messages, .news-list, .show_bar_block').on('click', 'a.link_status span.label_discuss', this.toggle_discuss)
  $('.chat-messages, .news-list, .show_bar_block').on('click', 'a.link_status span.label_approve', this.toggle_approve)

  #  $('body').on('click', '#comment_text_area', this.autosize)
  $('body').on('click', 'form.comment_add textarea', this.autosize)

  $('form.comment_add').on('keypress', 'textarea', this.submit_enter)

  #  $('body').on('click', '.expand_button', this.comments_collapse)

  #  check if url contain anchor
  myLink = document.location.toString();
  if (myLink.match(/comment_(\d+)/))
    $('#comment' + myLink.match(/comment_(\d+)/)[1]).effect("highlight", 3000);
    return false;

@comments_sumbit = ->
  this.submit_enter = (e) ->
    if e.keyCode == 13
      $(this).closest('form').trigger 'submit'

  $('form.comment_add').on('keypress', 'textarea', this.submit_enter)

@textarea_autosize = ->
  this.autosize = ->
    $(this).autosize()

  $('body').on('click', 'form.comment_add textarea', this.autosize)
