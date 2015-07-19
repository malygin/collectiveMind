@init_services = ->
# panel filter by discontents on 3d stage
  $('#opener').on 'click', ->
    panel = $('#slide-panel')
    if panel.hasClass('visible')
      panel.removeClass('visible').animate 'margin-left': '-400px'
    else
      panel.addClass('visible').animate 'margin-left': '0px'

  ### sort button active ###
  $('.sort_btn').click ->
    $('.sort_btn').removeClass 'active'
    $(this).addClass 'active'

  # button show hints
  $('#popover_button_1').click ->
    $(this).toggleClass 'active'
    if $(this).hasClass('active')
      $(this).html($(this).find('i')).append 'Закрыть подсказки'
    else
      $(this).html($(this).find('i')).append 'Открыть подсказки'
    $('.tooltip1').tooltip 'toggle'

  $('[data-toggle=tooltip]').tooltip()
  $('.knob').knob
    width: 36
    height: 36
    readOnly: true


  $('.questionsCarousel').carousel interval: false
  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  if $('.popup-explanation').length
    if !$('.popup-explanation').hasClass('shown_intro')
      $.magnificPopup.open
        items: src: '.popup-explanation'
        type: 'inline'
        closeOnContentClick: false
        closeOnBgClick: false
        closeBtnInside: false
        showCloseBtn: false
        enableEscapeKey: false

  ### magnific popup close button ###
  $('.close_magnific').click ->
    magnificPopup = $.magnificPopup.instance
    magnificPopup.close()

  open_dd = (opener, win) ->
    opener.addClass 'active'
    win.addClass 'active'

  close_dd = (opener, win) ->
    opener.removeClass 'active'
    win.removeClass 'active'
    win.find('.collapse.in').removeClass 'in'
    win.find('[data-toggle="collapse"]').addClass 'collapsed'

  $('.drop_opener').click ->
    me = $(this)
    dd_open_id = me.attr('data-dd-opener')
    dd_win = $('#' + dd_open_id)
    if me.hasClass('active')
      close_dd me, dd_win
    else
      open_dd me, dd_win
  $('.dd_close').click ->
    me = $(this)
    dd_close_id = me.attr('data-dd-closer')
    dd_opener = $('.drop_opener[data-dd-opener=' + dd_close_id + ']')
    dd_win = $('#' + dd_close_id)
    close_dd dd_opener, dd_win

  # height of tabs on 1st stafe
  max_item_h = 0
  $('.c1-item').each ->
    cur_height = $(this).innerHeight()
    if cur_height > max_item_h
      max_item_h = cur_height
    return
  $('.c1-item-inner').each ->
    $(this).css 'height', max_item_h + 'px'
    return
  $('.client-one .owl-nav').css 'height', max_item_h + 'px'
  wrapper_w = 0
  $('.owl-item').each ->
    wrapper_w += $(this).innerWidth()
    return
  content_w = $('.owl-carousel').innerWidth()
  if wrapper_w < content_w
    $('.nav-tabs').css 'padding', '0'
    $('.owl-nav').css 'display', 'none'

  $('.with_arrow').click ->
    $(this).find('i.collapse_arrow').toggleClass 'fa-rotate-90'
    if $(this).find('i.collapse_arrow').hasClass('fa-rotate-90')
      $(this).find('i.collapse_arrow').attr('title', 'Свернуть')
    else
      $(this).find('i.collapse_arrow').attr('title', 'Развернуть')

  $('.with_plus').click ->
    $(this).find('i.collapse_plus').toggleClass('fa-plus').toggleClass('fa-minus')


