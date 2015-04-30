# используемые

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
#= require novation/novations

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

  vote_buttons()

  parse_my_journal_links()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

  # аутосайз полей в кабинете
  $('#cabinet_form textarea').autosize()

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
  comments_expandable_column()
#  vote_scripts()

  ### sort button active ###
  # выделение кнопок сортировки
  $('.sort_btn').click ->
    $('.sort_btn').removeClass 'active'
    $(this).addClass 'active'
    return

  # просмотр несовершенства в голосовании
  $('.vote_open_detail_imperf').click ->
    $('i', this).toggleClass 'fa-angle-right'
    $('i', this).toggleClass 'fa-angle-left'
    $('.item_expandable_imperf').not($(this).parents('.vote_item').find('.item_expandable_imperf')).removeClass 'opened'
    $(this).parents('.vote_item').find('.item_expandable_imperf').toggleClass 'opened'


#  # Выбор несовершенства для идеи
#  ch_its = $('.item', '.checked_items').length
#  unch_its = $('.item', '.unchecked_items').length
#  $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
#
#  $('.check_push_box').click ->
#    item = $(this).closest('.item').detach()
#    if $(this).is(':checked')
#      $('.checked_items').append item
#      ch_its++
#      unch_its--
#      $('.hideable_checks').show()
#      $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
#      $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
#    else
#      $('.unchecked_items').append item
#      ch_its--
#      unch_its++
#      if ch_its == 0
#        $('.hideable_checks').hide()
#      $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
#      $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
#    return

  # Открывает и закрывает стикеры в кабинете
  $('.open_sticker').click ->
    stick_id = $(this).attr('data-for')
    $(stick_id).show()
    return
  $('.sticker_close').click ->
    stick_id = $(this).attr('data-for')
    $(stick_id).hide()
    return

