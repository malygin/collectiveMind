@init_procedure = ->
  tooltipInit('[data-toggle=tooltip]')
  progressDiagramInit('.knob')
  carousellInit('.questionsCarousel')
  carousellInit('.carousel', 4000)
  colors_for_content()

  #popup for all links with target source
  $('.open-popup').click ->
    modalInit('#popup-'+$(this).data('target'))

  # аутосайз полей
  $('textarea').not('.without_autosize').autosize()

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
    tooltipToggle('.tooltip1')

  KindsOfAccordionLists()

  # intro panel with goals of stage
  if $('.md-modal-explanation').length and !$('.md-modal-explanation').hasClass('shown_intro')
    modalInit('.md-modal-explanation', withClose: false)

  # vote modal open
  if $('.md-modal-vote').length > 0
    $('.md-modal-vote').modal('show')

  # drop panel for header menu
  $('.drop_opener, .dd_close').click ->
    $('#' + $(this).attr('data-dd')).toggleClass('active')

  # height of tabs on 1st stafe
  $('.c1-item-inner').each ->
    $(this).css 'height', ($('#first-stage-slider').innerHeight()-6) + 'px'

  $('.avatar_of_collection').on 'click', ->
    avatar = $(this).data('avatar')
    $('#collection_avatar').val(avatar)

  #@todo check this shit
  $('.avatar_icon').click ->
    $('.avatar_icon').removeClass 'active'
    $(this).addClass 'active'

  # for hint and notice on questons substage of  1st stage
  #@todo check this shit
  $('.notice-button').click ->
    $('#hint_question_' + $(this).data('question')).removeClass 'close-notice'
  $('.close-button,.answer-button,.li_aspect').click ->
    $('.hint').addClass 'close-notice'
  $('.answer-button,.li_aspect').click ->
    $('.notice').addClass 'close-notice'

# two kinds of accordion lists
@KindsOfAccordionLists = ->
  $('.with_arrow').click ->
    $(this).find('i.collapse_arrow').toggleClass 'fa-rotate-90'
  $('.with_plus').click ->
    $(this).find('i.collapse_plus').toggleClass('fa-plus').toggleClass('fa-minus')




