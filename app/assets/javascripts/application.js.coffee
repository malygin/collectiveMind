#= require jquery
#= require jquery_ujs
#= require_tree
#= require jquery.ui.all
#= require twitter/bootstrap
#= require autocomplete-rails
#= require bootstrap-wysihtml5/b3
#= require bootstrap-wysihtml5/locales/ru-RU

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

@disable_send_button= ->
  $('#send_post').toggleClass('disabled')
$('.score_class').on 'click', ->
  $('.score_class').css('text-decoration','none').css('background-color','transparent')
  $(this).css('text-decoration','underline').css('background-color','#ddeaf4')

@load_discontent_for_cond= (el)->
  console.log($('#select_'+el).val())
  $.ajax({
    type: "POST",
    url: "/project/1/plan/posts/get_cond",
    data: { pa: $('#select_'+el).val() },

  })

@activate_htmleditor= ->
  myCustomTemplates = lists: (locale) ->
    "<li>" + "<div class='btn-group'>" +
    "<a class='btn btn-default btn' data-wysihtml5-command='insertUnorderedList' title='" +
    locale.lists.unordered + "' tabindex='-1'><img src='/assets/edit2.ico'></a>" +
    "<a class='btn btn-default btn' data-wysihtml5-command='insertOrderedList' title='" +
    locale.lists.ordered + "' tabindex='-1'><img src='/assets/edit.ico'></a>" +
    "<a class='btn btn-default btn' data-wysihtml5-command='Outdent' title='" +
    locale.lists.outdent + "' tabindex='-1'><img src='/assets/edit4.ico'></i></a>" +
    "<a class='btn btn-default btn' data-wysihtml5-command='Indent' title='" +
    locale.lists.indent + "' tabindex='-1'><img src='/assets/edit3.ico'></i></a>" + "</div>" + "</li>"

  $(document).ready ->
    $(".wysihtml5").each (i, elem) ->
      $(elem).wysihtml5
        "font-styles": true
        emphasis: true
        lists: true
        html: true
        link: true
        image: true
        color: true
        customTemplates: myCustomTemplates
