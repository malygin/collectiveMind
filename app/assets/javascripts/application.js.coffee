# @todo используемые

#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.autosize
#= require history_jquery
#= require jquery.tube.min

#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require velocity.min
#= require velocity.ui.min
#= require selectize
#= require tinymce

#= require websocket_rails/main
#= require messenger/messenger.min
#= require jquery.ui.chatbox

#= require utils
#= require plugins
#= require comments
#= require resources

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
#= require discontent/discontents
#= require concept/concepts

#= require custom_ready

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

  expert_news()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

  # Раскрашиваем аспекты согласно цвету, который в них зашит

  #  $('.color_me').each ->
  #    $(this).css $(this).attr('data-me-action'), $(this).attr('data-me-color')
  #    return

  # Используется в кабинете на стадии несовершенств, во вспомогательной технике
  $('.open-popup').each ->
    stageNum = $(this).attr('data-placement')
    popupNum = $(this).attr('data-target')
    src = '#popup-' + stageNum + '-' + popupNum
    $(this).magnificPopup
      type: 'inline'
      items: [{
        src: src
        type: 'inline'
      }]
      callbacks:
        open: ->
          me_id = $.magnificPopup.instance['items'][0]['src']
          pop_h = $('.modal_content', me_id).height()
          $('.modal_content', me_id).css
            'height': pop_h + 'px'
            'overflow': 'hidden'
          return
        close: ->
          return
    return

  ### slide panel 3rd stage ###

  $('#opener').on 'click', ->
    panel = $('#slide-panel')
    if panel.hasClass('visible')
      panel.removeClass('visible').animate 'margin-left': '-400px'
    else
      panel.addClass('visible').animate 'margin-left': '0px'

  show_comments_hover()
  activate_perfect_scrollbar()
  post_colored_stripes()
  colors_discontents()


#show comments panel on post hover
@show_comments_hover = ->
  $('.ch_action').hover ->
    ch_id = $(this).attr('data-for')
    $('.comments_icon[data-for= "' + ch_id + '"]').toggleClass 'active'
    $('#' + ch_id).toggleClass 'active'
    return

# perfect scrollbar
@activate_perfect_scrollbar = ->
  $('.ps_cont.half_wheel_speed').perfectScrollbar wheelSpeed: 0.3
  $('.ps_cont').perfectScrollbar()

#  post colored stripes
#  показ цветных полосок -> упростить
@post_colored_stripes = ->
  count_themes_width = (cont) ->
    width = 0
    $('#' + cont + ' .tag-stripes').each ->
      width = width + $(this).outerWidth()
      return
    width + 100

  $('.post-theme').each ->
    curId = $(this).attr('id')
    $(this).width count_themes_width(curId)
    return
  $('.post-theme').hover ->
    curId = $(this).attr('id')
    $('#' + curId + ' .tag-stripes').hover ->
      $('#' + curId + ' .tag-stripes').removeClass 'active'
      $(this).addClass 'active'
      return
    return
  $('.post-theme').mouseover ->
    $(this).addClass 'shown'
    $(this).closest('.themes_cont').addClass 'themesShown'
    return
  $('.post-theme').mouseleave ->
    $(this).removeClass 'shown'
    $(this).closest('.themes_cont').removeClass 'themesShown'
    return
  $('.tag-stripes').mouseover ->
    $(this).closest('.post-theme').width count_themes_width($(this).closest('.post-theme').attr('id'))
    return


  # временно!!!
@colors_discontents = ->
  color_item = (object, action, color) ->
    object.css action, '#' + color
    return

  $('.color_me').each ->
    me = $(this)
    type = me.attr('data-me-type')
    if type == 'aspect'
      color = $colors_imperf_codes[me.attr('data-me-color')]
    else if type == 'imperf'
      color = $colors_imperf_codes[me.attr('data-me-color')]
    action = me.attr('data-me-action')
    color_item me, action, color
    return

$colors_imperf_codes = [
  'd3a5c9'
  'a7b3dd'
  '87a9f3'
  '8d9caf'
  '85dbf2'
  '91c5d0'
  '8ad2be'
  'a6d1a6'
  'd7d49d'
  'f3e47d'
  'f9bf91'
  'eca3b7'
  'e67092'
  '6ea3f1'
  'a5bdad'
  '81dad6'
  '96afb6'
  'be85ca'
  'fbcd82'
  '79889b'
  'd3e18c'
  'eea266'
  'b7e3f0'
  '7dc7f6'
  'f7947f'
  'e2de95'
  '8fbce5'
  '7181d9'
  'b9daa3'
  'dc7674'
  '77b7f5'
  'ff7b67'
  'e8aa79'
  'd0596c'
  'ac87bd'
  'e89ec3'
  'feb497'
  'b67c94'
  '8790d3'
  '89b5f4'
  'b46a6b'
  'ff8f5f'
  '88a0ce'
  'cd97c9'
  '7391da'
  'fdaa68'
  'b45f58'
  '8fb5e6'
  'fea1cd'
  '978ac2'
]