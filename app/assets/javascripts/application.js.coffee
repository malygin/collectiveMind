
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

#= require isotope.pkgd.min
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


$ ->
  start_vote()

  init_cabinet()

  init_services()

  vote_scripts()

  comments_feed()

  expert_news()

  parse_my_journal_links()

  check_and_push()

  show_comments_hover()

  activate_perfect_scrollbar()

  post_colored_stripes()

  colors_for_content()

  comments_expandable_column()

#  профиль -  доделать
  $('.avatar_icon').click ->
    $('.avatar_icon').removeClass 'active'
    $(this).addClass 'active'

  $("form#auth-form1").bind "ajax:success", (e, data, status, xhr) ->
    $('#error_explanation').html 'Авторизация успешна, грузим список доступных процедур'
    location.reload()

  $("form#auth-form1").bind "ajax:error", (e, data, status, xhr) ->
    $('#error_explanation').html data.responseText




















