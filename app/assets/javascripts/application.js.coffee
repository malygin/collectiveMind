# @todo используемые

#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.autosize
#= require history_jquery

#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require selectize
#= require tinymce

#= require websocket_rails/main
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

#= require excanvas
#= require jquery.knob

#= require waypoints.min
#= require jquery.contenthover.min
#= require perfect-scrollbar.jquery.min

#= require custom.js

#= require brave
#= require brave2
#= require brave3

#= require velocity.min
#= require velocity.ui.min
#= require isotope.pkgd.min

#= require underscore
#= require_tree ./templates
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require discontent/discontents


# @todo load initialization
$ ->
  start_vote()

  start_play()

  comments_feed()

  selectize()

  search()
  post_form()

  activate_htmleditor()
  autocomplete_initialized()
  activate_add_aspects()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return
