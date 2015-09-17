@init_procedure = ->
  tooltipInit()
  progressDiagramInit('.knob')
  carousellInit('.questionsCarousel')
  carousellInit('.carousel', 4000)
  colors_for_content()
  KindsOfAccordionLists()
  expert_news()

  #modal for all links with target source
  $('.open-modal').click ->
    modalInit('#modal-'+$(this).data('target'))

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

  # intro panel with goals of stage
  if $('.md-modal-explanation').length and !$('.md-modal-explanation').hasClass('shown_intro')
    modalInit('.md-modal-explanation', withClose: false)

  # vote modal open
  if $('.md-modal-vote').length > 0
    $('.md-modal-vote').modal('show')

  # drop panel for header menu
  $('.drop_opener, .dw_close').click ->
    # close opened news
    $('.md-news-notice a').each ->
      $(this).addClass('collapsed') unless $(this).hasClass('collapsed')
    $('.md-news-article').each ->
      $(this).removeClass('in')
    $('#' + $(this).attr('data-dd')).toggleClass('active')

  # height of tabs on 1st stafe
#  $('.slider-item').each ->
#    $(this).css 'height', ($('#first-stage-slider').innerHeight()-6) + 'px'

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

# чтение отдельной новости эксперта в попапе
@expert_news = ->
  this.expert_news_read = ->
    project_id = $(this).data('project')
    news_id = $(this).data('id')
    # проверяем и добавляем класс, чтобы исключить дублирование лога
    read = $(this).hasClass('read')
    if project_id and news_id and !read
      $(this).addClass('read')
      # убираем статус
      $(this).find('.status_news').html('')
      unless($(".md-expert-news .md-news-notice a:not(.read)").length)
        $('#open_expert_news').removeClass('active')
      $.ajax
        url: "/project/#{project_id}/news/#{news_id}/read"
        type: "get"
        dataType: "script"

  $('.md-expert-news').on('click', '.md-news-notice a', this.expert_news_read)




