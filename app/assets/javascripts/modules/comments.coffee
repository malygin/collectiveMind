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
    sibling_col = parent_col.siblings('.exp_col')
    current_button = $(this)
    if parent_col.hasClass('active')
      parent_col.toggleClass 'active'
      sibling_col.toggleClass 'hidden'
    else
      parent_col.toggleClass 'hidden'
      sibling_col.toggleClass 'active'
      current_button = $('.exp_col.active').find('.exp_button')

    new_title = current_button.attr('data-new')
    old_title = current_button.attr('data-original-title')
    current_button.attr('data-original-title', new_title).attr('data-new', old_title)

# сворачивание комментов
@comments_collapse_column = ->
  $('#comments').on 'shown.bs.collapse', ->
    $('.comments_action').text $('.comments_action').data('data-original-action')
  $('#comments').on 'hidden.bs.collapse', ->
    $('.comments_action').text $('.comments_action').data('data-new-action')

@comments_feed = ->
  this.edit_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    form = JST['templates/comment_edit_form']({ comment_id: id, content: $.trim($('#comment_text_' + id).html()) })
    $('#comment_text_' + id).html(form)
    $('#redactor_comment_' + id).fadeOut()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeIn()
    $('#form_edit_comment_' + id).collapse('show')
    textarea_autosize()
    comments_submit()

  this.edit_cancel = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    $('#comment_text_' + id).html($('#form_edit_comment_' + id + ' textarea').val())
    $('#form_edit_comment_' + id).fadeOut().remove()
    $('#cancel_comment_' + id + ' .edit-cancel').fadeOut()
    $('#redactor_comment_' + id).fadeIn()

  this.reply_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    comment = $(this).data('comment')
    form = JST['templates/comment_reply_form']({ post_id: id, comment_id: comment, content: $('#user_name_' + comment).text().trim() + ', ' })
    $('#comment' + comment).after(form)
    $('#reply_form_' + comment).collapse('show')
    $('#reply_comment_' + comment).toggleClass('reply-comment cancel-reply')
    textarea_autosize()
    comments_submit()

  this.cancel_reply = (e) ->
    e.preventDefault()
    $(this).closest('.media.comment').next('form').collapse('hide').remove()
    $(this).toggleClass('reply-comment cancel-reply')

  this.activate_button = ->
    form = $(this).closest('form')
    sendButton = form.find('.send-comment')
    if (this.value? and this.value.length > 1)
      sendButton.removeClass('disabled')
    else
      sendButton.addClass('disabled')

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

  textarea_autosize()
  comments_submit()

  #  check if url contain anchor
  myLink = document.location.toString()
  if (myLink.match(/comment_(\d+)/))
    $('#comment' + myLink.match(/comment_(\d+)/)[1]).effect("highlight", 3000)
    return false

@comments_submit = ->
  $('form.comment_add').off('keypress', 'textarea').on('keypress', 'textarea', this.submit_enter)

@textarea_autosize = ->
  $('body').on('click', 'form.comment_add textarea', this.autosize)

