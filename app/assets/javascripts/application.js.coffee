#= require jquery
#= require jquery_ujs
#= require_tree
#= require jquery.ui.all
#= require twitter/bootstrap
#= require autocomplete-rails

$('#modal_help').modal
  keyboard: false
  backdrop: 'static'

$('#modal_help').on 'hidden.bs.modal', ->
  $('#help_question').submit()

@get_life_tape_form = ->
  $('#new_life_tape').css 'display','block'
  $("#add_record").fadeOut("slow").hide()
  $("#new_life_tape").animate {height: 100}, "normal"
  $("#button_block").stop().show().animate {
    left:$('#new_life_tape').width() - 370
    opacity:1.000 }

@reset_life_tape_form = ->
  $("#button_block").animate({left:0, opacity:0.000 }, 'normal', ->
    $("#button_block").css 'display', 'none')
  $("#new_life_tape").animate {
    height: 0
  }, "normal",  ->
    $('#new_life_tape').css('display','none')
  $("#add_record").fadeIn('slow')

@show_filter_aspects_button = ->
  $('#filter-aspect').stop().show().animate {
    left: 15
    opacity: 1}

@reset_filter_aspects = ->
  $('input[type=checkbox]').prop('checked','')
  show_filter_aspects_button()

@activate_button = (el)->
  if el.value? and el.value!=''
    $('#send_post').removeClass('disabled')
  else
    $('#send_post').addClass('disabled')

@activate_modal_send = (el)->
  if $( ".radio input:checked" ).length == 1
    $('#send').removeClass('disabled')

@remove_block = (el)->
  $('#'+el).remove()

@disontent_form_submit= ->
  $('#send_post').html('Ищем совпадения ...')
  $('#send_post').toggleClass('disabled')

#update comment

#@update_life_tape_comment = (project_id,post_id,comment_id,comment_content)->
#  comment_form = '<form accept-charset="UTF-8" action="/project/'+project_id+'/life_tape/posts/'+post_id+'/comments/'+comment_id+'/edit" data-remote="true" id="update_comment_life_tape_post" method="put">
#  <textarea class="form-control" cols="40" id="comment_text_area" name="life_tape_comment[content]" onkeyup="activate_button(this);"
#  placeholder="Ваш комментарий" rows="20" style="height: 70px;">'+comment_content+'</textarea>
#  <div class="pull-right"><input class="btn btn-sm btn-success disabled" id="send_post"  type="button" onclick="send_comment_content(comment_id);" value="Отправить" /></div>
#  </form><div class="text-success" id="comment_success" style="display:none;">Комментарий успешно добавлен</div>'
#  $('#comment_content_'+comment_id).html(comment_form)
#  $('#update_comment_content').fadeOut("slow").hide()
#
#@send_comment_content = (comment_id)->
#  content_val = $('#comment_text_area').val()
#  $('#comment_content_'+comment_id).html(content_val)
#  $('#update_comment_content').fadeIn('slow')

#$('#new_life_tape').css 'display','block'
#$("#add_record").fadeOut("slow").hide()
#$("#new_life_tape").animate {height: 100}, "normal"
#$("#button_block").stop().show().animate {
#  left:$('#new_life_tape').width() - 370
#  opacity:1.000 }

