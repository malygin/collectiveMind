#show comments panel on post hover
@show_comments_hover = ->
  $('.ch_action').unbind().hover ->
    ch_id = $(this).attr('data-for')
    $('.comments_icon[data-for= "' + ch_id + '"]').toggleClass 'active'
    $('#' + ch_id).toggleClass 'active'


# сворачивание комментов и скролл
@comments_expandable_column = ->
  $('.exp_button').click ->
    parent_col = $(this).parents('.exp_col')
    if parent_col.hasClass('active')
      parent_col.toggleClass 'active'
      parent_col.siblings('.exp_col').toggleClass 'hidden'
      new_title = $(this).attr('data-new')
      old_title = $(this).attr('data-original-title')
      $(this).attr('data-original-title',new_title).attr('data-new',old_title)
    else
      parent_col.toggleClass 'hidden'
      parent_col.siblings('.exp_col').toggleClass 'active'
      new_title = $('.exp_col.active').find('.exp_button').attr('data-new')
      old_title = $('.exp_col.active').find('.exp_button').attr('data-original-title')
      $('.exp_col.active').find('.exp_button').attr('data-original-title',new_title).attr('data-new',old_title)

# сворачивание комментов
@comments_collapse_column = ->
  $('#comments').on 'shown.bs.collapse', ->
    $('.comments_action').text 'свернуть'
  $('#comments').on 'hidden.bs.collapse', ->
    $('.comments_action').text 'развернуть'

@comments_feed = ->
  this.edit_comment = (e)->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    stage = path.replace('/posts', '').replace('/', '_')
    form = $('<form class="form-group comment_add collapse" accept-charset="UTF-8" action="/project/' + project + '/' + path + '/' + id + '/update_comment" data-remote="true" id="form_edit_comment_' + id + '" method="post"/>')
    form.append('<input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put">')
    form.append('<div class="input_cont"><textarea name="content" placeholder="Ваш комментарий" >' + $.trim($('#comment_text_' + id).html()) + '</textarea></div>')
    form.append('<button class="btn send-comment" type="submit"><span class="bold"><i class="fa fa-reply theme_font_color"></i></span></button>')
    $('#comment_text_' + id).html(form)
    $('#cancel_comment_' + id).append('<a href="#" class="edit-cancel" style="display:none" data-id="' + id + '"><span class="label label-danger">Отменить</span></a>')
    $('#redactor_comment_' + id).fadeOut()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeIn()
    $('#form_edit_comment_' + id).collapse('show')
    textarea_autosize()
    comments_sumbit()

  this.edit_cancel = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    $('#comment_text_' + id).html($('#form_edit_comment_' + id + ' textarea').val())
    $('#form_edit_comment_' + id).fadeOut().remove()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeOut()
    $('#redactor_comment_' + id).fadeIn()
    $('#cancel_comment_' + id).html('')

  this.cancel_reply = (e) ->
    e.preventDefault()
    $(this).closest('.media.comment').next('form').collapse('hide').remove()
    $(this).toggleClass('reply-comment cancel-reply')

  this.reply_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    comment = $(this).data('comment')
    stage = path.replace('/posts', '').replace('/', '_')
    form = $('<form class="form-group comment_add collapse" accept-charset="UTF-8" action="/project/' + project + '/' + path + '/' + id + '/add_comment?comment=' + comment + '" data-remote="true" id="reply_form_' + comment + '" method="post"/>')
    form.append('<input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put">')
    form.append('<div class="input_cont"><textarea name="' + stage + '_comment[content]" placeholder="Ваш комментарий" ></textarea></div>')
    form.append('<button class="btn send-comment" type="submit"><span class="bold"><i class="fa fa-reply theme_font_color"></i></span></button>')
    $('#comment' + comment).after(form)
    $('#reply_form_' + comment).collapse('show')
    $('#reply_comment_' + comment).toggleClass('reply-comment cancel-reply')
    $('#reply_form_' + comment + ' textarea').html($('#user_name_' + comment).text().trim() + ', ')
    textarea_autosize()
    comments_sumbit()

  this.activate_button = ->
    form = $(this).closest('form')
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
      e.preventDefault()
      if this.value? and this.value.length > 1
        $(this).closest('form').trigger 'submit'
      return false

  $('.chat-messages').on('click', 'a.edit-comment', this.edit_comment)
  $('.chat-messages').on('click', 'a.edit-cancel', this.edit_cancel)
  $('.chat-messages').on('click', 'button.reply-comment', this.reply_comment)
  $('.chat-messages').on('click', 'button.cancel-reply', this.cancel_reply)

  $('.form-new-comment,.chat-messages').on('keyup', 'textarea.comment-textarea', this.activate_button)

  $('body').on('click', 'form.comment_add textarea', this.autosize)

  $('form.comment_add').on('keypress', 'textarea', this.submit_enter)

  #  check if url contain anchor
  myLink = document.location.toString()
  if (myLink.match(/comment_(\d+)/))
    $('#comment' + myLink.match(/comment_(\d+)/)[1]).effect("highlight", 3000)
    return false

@comments_sumbit = ->
  this.submit_enter = (e) ->
    if e.keyCode == 13
      e.preventDefault()
      if this.value? and this.value.length > 1
        $(this).closest('form').trigger 'submit'
      return false

  $('form.comment_add').on('keypress', 'textarea', this.submit_enter)

@textarea_autosize = ->
  this.autosize = ->
    $(this).autosize()

  $('body').on('click', 'form.comment_add textarea', this.autosize)

@add_comment_by_enter = ->
  if $('input[id^=_comment_content]').length > 0
    $('input[id^=_comment_content]').keypress = (e)->
      if (e.which == 10 || e.which == 13)
        this.parent.submit()
      return