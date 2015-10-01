
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.autosize

#= require bootstrap.min

#= require utils
#= require_tree ./modules
#= require cabinet
#= require procedure
#= require vendor
#= require plugins/slider

# from yan's markup
#= require jquery.magnific-popup.min
#= require owl.carousel.min
#= require respond.min
#= require html5shiv
#= require excanvas
#= require jquery.knob
#= require waypoints.min
#= require jquery.contenthover.min
#= require perfect-scrollbar.jquery.min
#= require dropdowns-enhancement

#= require underscore
#= require_tree ./templates
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink

#= require_tree ./backbone_scripts

# GANTT
#= require gantt/date
#= require gantt/ganttDrawer
#= require gantt/ganttGridEditor
#= require gantt/ganttMaster
#= require gantt/ganttTask
#= require gantt/ganttUtilities
#= require gantt/i18nJs
#= require gantt/jquery.dateField
#= require gantt/jquery.JST
#= require gantt/jquery.livequery.min
#= require gantt/jquery.browser.min
#= require gantt/jquery.timers
#= require gantt/platform

#= require websockets/websockets_load.js.erb
#= require websockets/notifications
#= require websockets/messenger.min

#= require jquery.shuffle.modernizr.min


$ ->
  init_procedure()
  init_cabinet()
  vote_scripts()
  notifications()
  slider_scripts()

  $("form#auth-form1").bind "ajax:success", (e, data, status, xhr) ->
    $('#error_explanation')
      .html 'Авторизация успешна, грузим список доступных процедур'
    location.reload()

  $("form#auth-form1").bind "ajax:error", (e, data, status, xhr) ->
    $('#error_explanation').html data.responseText
