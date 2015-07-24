@init_procedure = ->

  colors_for_content()

  # sort button active
  $('.sort_btn').click ->
    $('.sort_btn').toggleClass 'active'

  # panel filter by discontents on 3d stage
  $('#opener').on 'click', ->
    new_margin = if $('#slide-panel').css('margin-left') == "0px" then -400 else 0
    $('#slide-panel').animate({'margin-left': new_margin})

  # button show hints
  $('.btn-tooltip').click ->
    $('.btn-tooltip').toggle()
    $('.tooltip1').tooltip 'toggle'

  $('.with_arrow').click ->
    $(this).find('i.collapse_arrow').toggleClass 'fa-rotate-90'

  $('.with_plus').click ->
    $(this).find('i.collapse_plus').toggleClass('fa-plus').toggleClass('fa-minus')

  $('[data-toggle=tooltip]').tooltip()

  $('.knob').knob
    width: 36
    height: 36
    readOnly: true

  $('.questionsCarousel').carousel interval: false
  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  # intro panel with goals of stage
  if $('.popup-explanation').length and  !$('.popup-explanation').hasClass('shown_intro')
    popupInit('.popup-explanation', false)

  # drop panel for header menu
  $('.drop_opener, .dd_close').click ->
    $('#' + $(this).attr('data-dd')).toggleClass('active')


  # height of tabs on 1st stafe
  $('.c1-item-inner').each ->
    $(this).css 'height', ($('#first-stage-slider').innerHeight()-6) + 'px'

  # аутосайз полей
  $('textarea').not('.without_autosize').autosize()





