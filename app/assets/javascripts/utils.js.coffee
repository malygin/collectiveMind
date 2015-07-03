#animate knob progress bar from data-end
@animateKnobChange = (el)->
  $(el).each ->
    cur =$(this);
    newValue = cur.data('end');
    $({animatedVal: cur.val()}).animate {animatedVal: newValue},
      duration: 3000,
      easing: "swing",
      step: ->
        cur.val(Math.ceil(this.animatedVal)).trigger("change")

#open magnific popup open
@magnificPopupOpen = (el)->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline',
    fixedContentPos: false,
    fixedBgPos:true

#open magnific popup close
@magnificPopupClose = (el)->
  $.magnificPopup.close
    items: {src: el},
    type: 'inline'

# get project id from url like /project/11/discontent/posts
@getProjectIdByUrl = ()->
  #  url = window.location.href.match(/\d+/g)
  #  return url[url.length-1]
  #  универсализация
  url = window.location.href.match(/project\/(\d+)/)
  if url
    return url[1]

# парсинг юрла для показа попапа
@parse_my_journal_links = ()->
  #  if window.location.href.indexOf("discontent/posts") > -1
  #  $('#comment_content_' + link.match(/comment_(\d+)/)[1]).effect("highlight", 3000);
  link = document.location.toString();
  if link.match(/project\/(\d+)/)
    project_id = link.match(/project\/(\d+)/)[1]
  if link.match(/jr_post=(\d+)/)
    post_id = link.match(/jr_post=(\d+)/)[1]
  if link.match(/jr_comment=(\d+)/)
    comment_id = link.match(/jr_comment=(\d+)/)[1]
  if link.match(/project\/(\d+)\/(\w+)\/posts/)
    stage = link.match(/project\/(\d+)\/(\w+)\/posts/)[2]

  if project_id and post_id and stage
    $.ajax
      url: "/project/#{project_id}/#{stage}/posts/#{post_id}"
      type: "get"
      dataType: "script"

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
      unless($(".expert_news_drop .dd_xprt_notice a:not(.read)").length)
        $('.drop_opener i').css 'color', '#9e9e9e'
      $.ajax
        url: "/project/#{project_id}/news/#{news_id}/read"
        type: "get"
        dataType: "script"

  $('.expert_news_drop').on('click', '.dd_xprt_notice a', this.expert_news_read)

# get new question in 1st stage
@getNextQuestion = (question, aspect)->
  # if we have more questions in aspect
  if($("#question_"+question).next().length)
    $("#questionsCarousel_"+aspect).carousel('next')
    $("#question_count_"+aspect).html(parseInt($("#question_count_"+aspect).html())+1)
  else
    # else we try to active next aspect
    $('#aspect_block_'+aspect).html('<div class="divider20"></div><h4 class="block-with-left-icon pull-left"><i class="left-icon fa fa-2x fa-comments"></i>Вы ответили на все вопросы по данному аспекту.</h4><span class="pull-right question_count"></span><div class="carousel-inner"></div>')
    $('#li_aspect_'+aspect).addClass('complete')
    if($(".li_aspect:not(.complete)").length)
      $('.li_aspect').removeClass('active')
      $('.slider-item').removeClass('active')
      $('#li_aspect_'+aspect).parent().find('.li_aspect:not(.complete):first').find('a').tab('show');
    else
      # else we have not more aspects, we just show greetings
      if($("#popup-greetings-text").length)
        magnificPopupOpen('#popup-greetings-text')
      else
        setTimeout (->
          window.location.reload(true)
          return
        ), 1000

# определение проставленных галочек при выборе несовершенств в левом слайдере
@check_discontents= (el)->
  arr = []
  $(el).find('input:checked').closest('.checkox_item').each (index, element) ->
    if $(element).data('discontent') == '*'
      arr = $(element).data('discontent')
      return false
    else
      arr.push(if $(element).data('discontent').match(/(\d+)/) then $(element).data('discontent').match(/(\d+)/)[1] else $(element).data('discontent'))
  return arr

#show comments panel on post hover
@show_comments_hover = ->
  $('.ch_action').unbind().hover ->
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

# цвета для несовершенств
@colors_discontents = ->
  color_item = (object, action, color) ->
    object.css action, '#' + color
    return

  $('.color_me').each ->
    me = $(this)
    type = me.attr('data-me-type')
    if type == 'imperf'
      color = $colors_imperf_codes[me.attr('data-me-color') % 49]
    if (type == 'aspect')
       color = $colors_aspect_codes[me.attr('data-me-color')];
    action = me.attr('data-me-action')
    if action and color
      color_item me, action, color
    return

# сворачивание комментов и скролл
@comments_expandable_column = ->
  $('.exp_button').click ->
    parent_col = $(this).parents('.exp_col')
    if parent_col.hasClass('active')
      parent_col.toggleClass 'active'
      parent_col.siblings('.exp_col').toggleClass 'hidden'
      new_title = $(this).attr('data-new')
      old_title = $(this).attr('data-original-title')
      $(this).attr('data-original-title',new_title).attr('data-new',old_title)

    else
      parent_col.toggleClass 'hidden'
      parent_col.siblings('.exp_col').toggleClass 'active'
      new_title = $('.exp_col.active').find('.exp_button').attr('data-new')
      old_title = $('.exp_col.active').find('.exp_button').attr('data-original-title')
      $('.exp_col.active').find('.exp_button').attr('data-original-title',new_title).attr('data-new',old_title)
    return

# сворачивание комментов
@comments_collapse_column = ->
  $('#comments').on 'shown.bs.collapse', ->
    $('.comments_action').text 'свернуть'
    return
  $('#comments').on 'hidden.bs.collapse', ->
    $('.comments_action').text 'развернуть'
    return

# выбор несовершенств и идей в кабинете
@check_and_push = ->
  ch_its = $('.item', '.checked_items').length
  unch_its = $('.item', '.unchecked_items').length
  $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
  $('#check0').click ->
    if  $("#check0").is(":checked")
      $("#unchecked_discontent_posts input:checkbox").prop('checked', true);
      $.each $('#unchecked_discontent_posts .item'), ->
        item = $(this).closest('.item').detach()
        item_id = $(item).attr('data-id')
        $('#discontents').find('.item[data-id=' + item_id + ']').remove()
        $('.checked_items').append item
        ch_its++
        unch_its--
        $('.hideable_checks').show()
        $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
        $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
    else
      $("input:checkbox").prop('checked', false)
      $.each $('.checked_items .item'), ->
        item = $(this).closest('.item').detach()
        item_id = $(item).attr('data-id')
        $('.unchecked_items').append item
        ch_its--
        unch_its++
        if ch_its == 0
          $('.hideable_checks').hide()
        $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
        $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'
  $('.check_push_box').click ->
    item = $(this).closest('.item').detach()
    item_id = $(item).attr('data-id')
    $('#discontents').find('.item[data-id=' + item_id + ']').remove()
    $('#ideas').find('.item[data-id=' + item_id + ']').remove()
    $('.checked_items').find('.item[data-id=' + item_id + ']').remove()
    if $(this).is(':checked')
      $('.checked_items').append item
      ch_its++
      unch_its--
      $('.hideable_checks').show()
      $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
      $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'

      ###Для 4 стадии, при выборе идеи мы добавляем в форму поле с ид идеи###

      if $('#for_hidden_fields').length > 0
        $('#for_hidden_fields').append '<input id="novation_post_concept_' + item_id + '" name="novation_post_concept[]" type="hidden" value="' + item_id + '"/>'
        $('.selected_concepts').append '<p class="bold" id="selected_concept_' + item_id + '">' + $(item).find('a.collapser_type1').text() + '</p>'
    else
      $('.unchecked_items').append item
      ch_its--
      unch_its++
      if ch_its == 0
        $('.hideable_checks').hide()
      $('.enter_lenght .ch_lenght').empty().append '(' + ch_its + ')'
      $('.enter_lenght .unch_lenght').empty().append '(' + unch_its + ')'

      ###Для 4 стадии, при выборе идеи мы добавляем в форму поле с ид идеи###

      if $('#for_hidden_fields').length > 0
        $('#for_hidden_fields').find('input#novation_post_concept_' + item_id).remove()
        $('.selected_concepts').find('p#selected_concept_' + item_id).remove()
    return

# поиск пользователей
@search = ->
  this.search_users = ->
    project_id = $('#search_users_project').attr("data-project")
    code_user = $('#search_users_project').attr("data-code")
    val = this.value
    if project_id and val
      $.ajax
        url: "/project/#{project_id}/users/search"
        type: "get"
        data:
          search_users_text: val
          code: code_user

  $('.search_text').on('change', 'input#search_users_text', this.search_users)

# подгрузка несовершенств при клике на аспект в форме добавления идеи
$('.add_disposts').on "click", (e) ->
  project_id = $(this).data('project')
  aspect_id = $(this).data('aspect')
  if project_id and aspect_id
    $.ajax
      url: "/project/#{project_id}/concept/posts/add_disposts"
      type: "put"
      dataType: "script"
      data:
        aspect: aspect_id

# поиск несовершенств в форме добавления идеи
$('#search_discontent').on "change", (e) ->
  project_id = $(this).data('project')
  val = this.value
  if project_id and val
    $.ajax
      url: "/project/#{project_id}/concept/posts/search_disposts"
      type: "put"
      dataType: "script"
      data:
        search_text: val

# @todo users checks
@user_check_field = (el, check_field)->
  optsel = $("#option_for_check_field")
  project_id = parseInt(optsel.attr('project'))
  table_name = optsel.attr('table_name')
  if ( $(el).is(":checked") )
    status = true
  else
    status = false
  if check_field != ''
    $.ajax
      url: "/project/#{project_id}/#{table_name}/posts/check_field"
      type: "get"
      data:
        check_field: check_field
        status: status

#цвет модального окна базы знаний
@color_modal_knowbase =->
  $('#myCarousel').on 'slid.bs.carousel', ->
    bgcolor = $('.myCarousel-target.active').attr('data-color');
    $('#myCarousel .header').css({background: bgcolor});
    $('.myCarousel-control').css({color: bgcolor});
    return

# цвета для аспектов и несовершенств временно!!!
$colors_aspect_codes = [
  'cfa7cc',
  'a4b1db',
  '88a2c3',
  '8a99ae',
  '8abdea',
  '8fc8d3',
  'a3bead',
  'a5cba2',
  'b9dd9d',
  'd7d69e',
  'e9dd93',
  'e7b288',
  'd59d9e'
]
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
