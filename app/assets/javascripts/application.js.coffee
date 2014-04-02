#= require jquery
#= require jquery_ujs
#= require_tree
#= require jquery.ui.all
#= require twitter/bootstrap
#= require autocomplete-rails
#= require bootstrap-wysihtml5/b3
#= require bootstrap-wysihtml5/locales/ru-RU
#= require selectize
#= require liFixar/jquery.liFixar



$('#modal_help').modal
  keyboard: false
  backdrop: 'static'

$('#modal_help').on 'hidden.bs.modal', ->
  $('#help_question').submit()
  $('#modal_help').remove()

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
  $.ajax({
    type: "POST",
    url: "/project/1/plan/posts/get_cond",
    data: { pa: $('#select_'+el).val() },

  })

@activate_htmleditor= ->
  $(".wysihtml5").each (i, elem) ->
    $(elem).wysihtml5
      "font-styles": true
      emphasis: true
      lists: true
      html: true
      link: true
      image: true
      color: true

$ ->
  $("#sortable").sortable()
  $("#sortable").disableSelection()
  $('#theall a:first').tab('show')

$('#sortable').sortable update: (event, ui) ->
  order = {}
  $("li",this).each (index) ->
    if parseInt($(this).attr('stage')) != (index+1)
      order[$(this).attr('id')] = index+1
  $.ajax
    url: "/project/1/knowbase/posts/sortable_save"
    type: "post"
    data:
      sortable: order

$(window).load ->
  $("#fixBlock").liFixar
    side: "top"
    position: 0

@select_discontent_for_union= (project,id)->
  sel = $('#selectize_tag :selected')
  $.ajax
    url: "/project/#{project}/discontent/posts/#{id}/add_union"
    type: "put"
    data:
      post_id: sel.val()


$(window).load ->
  $select = $("#selectize_tag").selectize
    labelField: "show_content"
    valueField: "id"
    sortField: "show_content"
    searchField: "show_content"
    create: false
    hideSelected: true
    onChange: (item) ->
      optsel = $(".option_for_selectize")
      project_id = parseInt(optsel.attr('project'))
      id = parseInt(optsel.attr('post'))
      select_discontent_for_union(project_id,id)
      selectize = $select[0].selectize
      selectize.removeOption(item)
      selectize.refreshOptions()
      selectize.close()
    render:
      item: (item, escape) ->
        short_item = item.show_content.split('<br/>')[0].replace('<b> что: </b>', '')
        return '<div>'+short_item+'</div>'
      option: (item, escape) ->
        return '<div>'+item.show_content+'</div>'
