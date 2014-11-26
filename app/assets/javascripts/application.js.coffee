#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.remotipart
#= require jquery.magnific-popup.min
#= require jquery.autosize

#= require totop/jquery.ui.totop
#= require totop/easing
#= require jquery.icheck


#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require autocomplete-rails-dev
#= require selectize
#= require liFixar/jquery.liFixar
#= require nvd3/d3.v2
#= require nvd3/nv.d3.min
#= require stats.js
#= require nvd3/stream_layers
#= require nvd3/multiBar
#= require nvd3/multiBarChart
#= require nvd3/app
#= require nvd3/axis
#= require nvd3/legend

#= require tinymce
#= require websocket_rails/main
#= require messenger/messenger.min
#= require select2
#= require wizard/jquery.bootstrap.wizard
#= require news
#= require notifications
#= require utils
#= require jquery.ui.chatbox
#= require jquery.slimscroll
#= require moderator_chat
#= require groups
#= require history_jquery

# @todo load initialization
sidebarHeight = 0;
$ ->
  comments_feed()

  notificate_my_journals()
  sidebar_for_small_screen()
  activate_htmleditor()
  autocomplete_initialized()
  estimate_color_select_init()
  create_moderator_chat()
  create_group_chat()







  $(".image-popup-vertical-fit").magnificPopup
    type: "image"
    closeOnContentClick: true
    mainClass: "mfp-img-mobile"
    image:
      verticalFit: true

  $("#color").colorpicker().on "changeColor", (ev) ->
    $("#color-holder").css "backgroundColor", ev.color.toHex()

  $(".chzn-select").each ->
    $(this).select2 $(this).data()

  $(".iCheck").iCheck
    checkboxClass: "icheckbox_square-grey"
    radioClass: "iradio_square-grey"

  $sidebar = $("#sidebar")



  $sidebar.on "hide.bs.collapse", (e) ->
    if e.target is this
      $sidebar.removeClass "open"
      $sidebar.addClass('nav-collapse')
      $(".content").css "margin-top", ""


  $('textarea.comment-textarea').on 'keyup', ->
    activate_button(this)

  $('.tooltips').tooltip()

  activate_htmleditor()

  $("select.estimate_select").each ->
    switch $(this).val()
      when '1.0'
        color = '#999'
      when '2.0'
        color = '#e5603b'
      when '3.0'
        color = '#fd8605'
      when '4.0'
        color = '#56bc76'
      else
        color = '#999'
    $(this).css 'color', color
    $(this).find("option[value='1.0']").css 'color', '#999'
    $(this).find("option[value='2.0']").css 'color', '#e5603b'
    $(this).find("option[value='3.0']").css 'color', '#fd8605'
    $(this).find("option[value='4.0']").css 'color', '#56bc76'


  $().UItoTop easingType: "easeOutQuart"

  $("#sortable").sortable()

  $("#sortable").disableSelection()

  autocomplete_initialized()

  if ($(window).width() > 1030)
    $('ul.panel-collapse.collapse').removeClass('collapse').addClass('open in')

  $('textarea').autosize()
  $('.liFixar').liFixar()
  $('.userscore').editable()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"
  #    wrap: false

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

  selectize_discontent()
  selectize_concept()

@history_click = (el)->
  state =
    title: el.getAttribute("title")
    url: el.getAttribute("href", 2)
  history.pushState state, state.title, state.url

@history_change = (link)->
  state =
    title: "Massdecision"
    url: link
  history.pushState state, state.title, state.url

@selectize_discontent= ->

  $select = $("#selectize_discontent").selectize
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

@selectize_concept= ->
  $select = $("#selectize_concept").selectize
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
      select_discontent_for_concept(project_id)
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
