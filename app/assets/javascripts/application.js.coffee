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
#= require websockets_load.js.erb
#= require groups
#= require history_jquery
#= require plugins
#= require comments
#= require resources
#= require visits
#= require visit_chart
#= require jquery.tube.min
#= require concept_play_movie.coffee

# @todo load initialization
sidebarHeight = 0;
$ ->
  start_play()
  comments_feed()

  estimate_stage()

  selectize()

  filterable()

  search()

  resources()

  post_form()

  record_visit()
  notificate_news()
  notifications()
  editable_groups()
  notificate_my_journals()
  sidebar_for_small_screen()
  activate_htmleditor()
  activate_wizard()
  autocomplete_initialized()
  create_moderator_chat()
  create_group_chat()
  activate_add_aspects()
  group_actions()
  visit_chart()

  $('.tooltips').tooltip()
  $("#sortable").sortable()
  $('textarea').autosize()
  $('.liFixar').liFixar()
  $('.userscore').editable()
  $("#sortable").disableSelection()
  $().UItoTop easingType: "easeOutQuart"

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

  #  $('textarea.comment-textarea').on 'keyup', ->
  #    activate_button(this)

  if ($(window).width() > 1030)
    $('ul.panel-collapse.collapse').removeClass('collapse').addClass('open in')

  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return
