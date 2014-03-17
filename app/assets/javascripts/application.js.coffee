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
  $('#aspects_list').submit()
#  $('#filter-aspect').stop().show().animate {
#    left: 15
#    opacity: 1}

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

$('.score_class').on 'click', ->
  $('.score_class').css('text-decoration','none').css('background-color','transparent')
  $(this).css('text-decoration','underline').css('background-color','#ddeaf4')

#@destroy_filter_aspects = (aspect) ->
#  $('#aspect_checkbox_'+aspect).fadeOut("slow")
#  setTimeout (-> $('#aspect_checkbox_'+aspect).remove()), 1000
#
#@edit_filter_aspects = (aspect,name,count) ->
#  name_str = '"'+name+'"'
#  aspect_name = '<span class="glyphicon glyphicon-ok text-success" type="button" style="cursor:pointer;" onclick="save_filter_aspects('+aspect+','+name_str+','+count+');"></span>
#                <input id="aspect_'+aspect+'"value="'+name+'" class="form-control">'
#
#  $('#aspect_checkbox_'+aspect).html(aspect_name)
#
#@save_filter_aspect = (aspect,name,count)->
#  filter_aspect = '<input id="aspect_1" name="aspects_filter[]" onclick="show_filter_aspects_button();" type="checkbox" value="1" />
#  <div class="pull-right">
#  <span class="glyphicon glyphicon-pencil text-success" onclick="edit_filter_aspects('+aspect+',"'+name+'",'+count+');" style="cursor:pointer;" type="button"></span>
#  <span class="glyphicon glyphicon-remove text-danger" onclick="destroy_filter_aspects('+aspect+');" style="cursor:pointer;" type="button"></span>
#  </div>'+name+'('+count+')'
#
#  $('#aspect_checkbox_'+aspect).html(filter_aspect)
