# @todo используемые

#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.remotipart
#= require jquery.autosize

#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require selectize
#= require history_jquery
#= require tinymce

# require websocket_rails/main
#= require messenger/messenger.min
#= require jquery.ui.chatbox

#= require utils
#= require plugins
#= require comments
#= require resources
#= require visit_chart
#= require jquery.tube.min
#= require concept_play_movie.coffee

#= require jquery.magnific-popup.min
#= require owl.carousel.min
#= require respond.min
#= require html5shiv
#= require waypoints.min
#= require jquery.knob
#= require excanvas
#= require dropdowns-enhancement
#= require jquery.contenthover.min
#= require custom.js

#= require brave
#= require brave2
#= require brave3

#= require velocity.min
#= require velocity.ui.min
#= require isotope.pkgd.min

# @todo не используемые

# require totop/jquery.ui.totop
# require totop/easing
# require jquery.icheck

# require liFixar/jquery.liFixar
# require nvd3/d3.v2
# require nvd3/nv.d3.min
# require stats.js
# require nvd3/stream_layers
# require nvd3/multiBar
# require nvd3/multiBarChart
# require nvd3/app
# require nvd3/axis
# require nvd3/legend

# require select2
# require wizard/jquery.bootstrap.wizard
# require jquery.slimscroll

# require news
# require notifications
#= require moderator_chat
#= require websockets_load.js.erb
# require groups

# @todo load initialization
sidebarHeight = 0;
$ ->
  start_vote()
  start_play()
  comments_feed()

  estimate_stage()

  selectize()

  filterable()

  sorterable()

  search()

  resources()

  post_form()

#  notificate_news()
#  notifications()
#  editable_groups()
#  notificate_my_journals()
  sidebar_for_small_screen()
  activate_htmleditor()
#  activate_wizard()
  autocomplete_initialized()
  create_moderator_chat()
#  create_group_chat()
  activate_add_aspects()
  visit_chart()
#  group_actions()

  first_stage_slider()

  $('.tooltips').tooltip()
  $("#sortable").sortable()
#  $('textarea').autosize()
#  $('.liFixar').liFixar()
  $('.userscore').editable()
  $("#sortable").disableSelection()
#  $().UItoTop easingType: "easeOutQuart"
  $("[data-toggle=\"popover\"]").popover()

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

#  $(".iCheck").iCheck
#    checkboxClass: "icheckbox_square-grey"
#    radioClass: "iradio_square-grey"

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
