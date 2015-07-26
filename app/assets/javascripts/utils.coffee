
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

@colors_for_content = ->
  $('.color_me').each ->
    me = $(this)
    switch me.attr('data-me-type')
      when 'imperf' then  color = $colors_imperf_codes[me.attr('data-me-color') % 49]
      when 'aspect' then  color = $colors_aspect_codes[me.attr('data-me-color')]
    action = me.attr('data-me-action')
    if action and color
      me.css action, '#' + color

@post_colored_stripes = ->
  # show long stripe only for non-active element and after this remove active from siblings
  $('.tag-stripes').hover ->
    if not $(this).hasClass 'active'
      $(this).addClass('active')
      $(this).siblings( ".tag-stripes" ).not(this).removeClass 'active'

# get project id from url like /project/11/discontent/posts
@getProjectIdByUrl = ()->
  url = window.location.href.match(/project\/(\d+)/)
  if url
    return url[1]

@getStageByUrl = ()->
  url = window.location.href.match(/project\/\d+\/(\S+)\//)
  if url
    return url[1]

@isProcedurePage = (path)->
  url = window.location.href
  return url.indexOf(path)>0 and url.indexOf("new")==-1

# парсинг юрла для показа попапа
@parse_my_journal_links = ()->
  #  if window.location.href.indexOf("discontent/posts") > -1
  #  $('#comment_content_' + link.match(/comment_(\d+)/)[1]).effect("highlight", 3000)
  link = document.location.toString()
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

# get new question in 1st stage
@getNextQuestion = (question, aspect)->
  # if we have more questions in aspect
  if($("#question_"+question).next().length)
    $("#questionsCarousel_"+aspect).carousel('next')
    $("#question_count_"+aspect).html(parseInt($("#question_count_"+aspect).html())+1)
  else
    # else we try to active next aspect
    $('#aspect_question_result_'+aspect).show()
    $('#aspect_block_'+aspect).hide()
    $('#li_aspect_'+aspect).addClass('complete')
    if($(".li_aspect:not(.complete)").length)
      $('#li_aspect_'+aspect).find('.slider-item').removeClass('active')
      $('#li_aspect_'+aspect).parent().find('.li_aspect:not(.complete):first').find('a').tab('show')
    else
      # else we have not more aspects, we just show greetings
      popupInit('#popup-greetings-text')




### functions only for cabinet ###
@save_plan_post = (input_id) ->
  $('#plan_post_tasks_gant').val(JSON.stringify(@ge.saveProject(), null, 2))
  $('#plan_post_novation_id').val($('#list_novations .active').attr('data-id'))
  $('input#' + input_id).click()

# выбор несовершенств и идей в кабинете
@checking_items_for_cabinet = ->
  ch_its = $('.item', '.checked_items').length
  unch_its = $('.item', '.unchecked_items').length
  $('.enter_length .unch_lenght').text '(' + unch_its + ')'
  # check all
  $('#check0').click ->
    $("#unchecked_discontent_posts input:checkbox").prop('checked', true)
    moved_its = $('#unchecked_discontent_posts .item').length
    $('#unchecked_discontent_posts .item').appendTo('.checked_items')
    ch_its+=moved_its
    unch_its-=moved_its
    $('.enter_length .ch_lenght').text '(' + ch_its + ')'
    $('.enter_length .unch_lenght').text '(' + unch_its + ')'
  # check one
  $('.check_push_box').click ->
    item = $($(this).data('item')).detach()
    if $(this).is(':checked')
      $('.checked_items').append(item.first())
      ch_its++
      unch_its--
    else
      $('.unchecked_items').append(item.first())
      ch_its--
      unch_its++
