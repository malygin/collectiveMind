@start_vote = ->
  if $('div[id^=popup-vote]').length > 0
    $.magnificPopup.open({
      items: {
        src: $('div[id^=popup-vote]')
      },
      type: 'inline'
    });
  return


@vote_scripts = ->

  this.vote_post = ->
    el = $(this)
    project_id = el.data('project')
    post_id = el.data('id')
    stage = el.data('stage')
    status = el.data('status')
    if project_id and post_id and stage and status
      $.ajax
        url: "/project/#{project_id}/#{stage}/posts/#{post_id}/vote"
        type: "put"
        dataType: "script"
        data:
          status: status
        success: (data, status, response) ->
          # визуализация при успешном ответе
          vote_transfer(el)

  this.vote_transfer = (el)->
    # начальная и конечная папки
    prev_folder_role = el.closest('.tab_vote_content').attr('data-vote-poll-role')
    next_folder_role = el.attr('data-vote-role')

    # проставляем статус и меняем роль
    vote_change_role(el)

    # удаляем пост из начальной папки
    vote_item = el.parents('.vote_item_cont').detach()

    # перемещаем пост в конечную папку
    $('[data-vote-poll-role = "' + next_folder_role + '"] .container > .row').append vote_item

    # изменяем счетчики
    prev_folder_counter = $('[data-vote-folder-role = "' + prev_folder_role + '"] .vote_counter')
    next_folder_counter = $('[data-vote-folder-role = "' + next_folder_role + '"] .vote_counter')
    prev_folder_counter.html(parseInt(prev_folder_counter.html())-1)
    next_folder_counter.html(parseInt(next_folder_counter.html())+1)

    # изменяем прогресс
    vote_progress(prev_folder_role, next_folder_role)

  this.vote_change_role = (el)->
    if el.hasClass('voted')
      el.attr('data-vote-role', $(this).attr('data-vote-default-role'))
    else
      el.attr('data-vote-role', 'all')

    el.toggleClass 'voted'

    # проставляем дефолтные значения для всех соседних кнопок
    el.siblings('.voted').each ->
      $(this).removeClass 'voted'
      $(this).attr('data-vote-role', $(this).attr('data-vote-default-role'))

  this.vote_progress = (prev_folder_role, next_folder_role)->
    progress = $('.vote_progress')
    all_posts = parseInt(progress.attr('data-progress-all'))
    voted_posts = parseInt(progress.attr('data-progress-voted'))
    if prev_folder_role == 'all'
      ++voted_posts
    else if next_folder_role == 'all'
      --voted_posts
    vote_perc = (voted_posts / all_posts) * 100
    progress.attr('data-progress-voted', voted_posts)
    progress.css 'width', vote_perc + '%'

  $('.vote_controls').on('click', '.vote_button', this.vote_post)



#  folder_len = {}
#  vote_icon_all = 'fa-home'
#
#  count_vote_items = (me) ->
#    $('.vote_item_cont', me).length
#
#  pb_stretch = (me, current, over) ->
#    vote_perc = (1 - current / over) * 100
#    me.css 'width', vote_perc + '%'
#    return
#
#  $('[data-vote-poll-role]').each ->
#    role = $(this).attr('data-vote-poll-role')
#    len = count_vote_items($(this))
#    folder_len[role] = len
#    $('[data-vote-folder-role = "' + role + '"] > .vote-folder > .vote_counter').text len
#    return
#  pb = $('.vote_progress')
#  all_len = folder_len['overall'] = count_vote_items('.all_vote')
#  pb_stretch pb, all_len, folder_len['overall']
#  $('.vote_button').click ->
#    role = $(this).attr('data-vote-role')
#    console.log role
#    if !$(this).hasClass('voted')
#      if $(this).siblings().hasClass('voted')
#        prev_role = $(this).siblings('.voted').attr('data-vote-role')
#        $(this).siblings('.voted').each ->
#          $(this).removeClass 'voted'
#          $('.fa', this).removeClass(vote_icon_all).addClass $(this).attr('data-icon-class')
#          return
#      $(this).addClass 'voted'
#      $('.fa', this).removeClass($(this).attr('data-icon-class')).addClass vote_icon_all
#      vote_item = $(this).parents('.vote_item_cont').detach()
#      $('[data-vote-folder-role = "' + role + '"] > .vote-folder > .vote_counter').text ++folder_len[role]
#
#      if prev_role
#        $('[data-vote-folder-role = "' + prev_role + '"] > .vote-folder > .vote_counter').text --folder_len[prev_role]
#      else
#        all_len--
#        $('[data-vote-folder-role = "all"] > .vote-folder > .vote_counter').text all_len
#        pb_stretch pb, all_len, folder_len['overall']
#      $('[data-vote-poll-role = "' + role + '"] .container>.row').append vote_item
#    else
#      $(this).removeClass 'voted'
#      $('.fa', this).removeClass(vote_icon_all).addClass $(this).attr('data-icon-class')
#      vote_item = $(this).parents('.vote_item_cont').detach()
#      $('[data-vote-folder-role = "' + role + '"] > .vote-folder > .vote_counter').text --folder_len[role]
#      $('.all_vote>.container>.row').append vote_item
#      all_len++
#      $('[data-vote-folder-role = "all"] > .vote-folder > .vote_counter').text all_len
#      pb_stretch pb, all_len, folder_len['overall']
#    item_e = $(this).parents('.item_expandable')
#    if item_e.hasClass('opened')
#      item_e.removeClass 'opened'
#      $(this).siblings('.vote_open_detail').children('i').toggleClass('fa-angle-right').toggleClass 'fa-angle-left'
#    return
#
#
#
#
## просмотр несовершенства в голосовании
#@vote_detail = ->
#  $('.vote_open_detail_imperf').click ->
#    $('i', this).toggleClass 'fa-angle-right'
#    $('i', this).toggleClass 'fa-angle-left'
#    $('.item_expandable_imperf').not($(this).parents('.vote_item').find('.item_expandable_imperf')).removeClass 'opened'
#    $(this).parents('.vote_item').find('.item_expandable_imperf').toggleClass 'opened'
#
#  $('.vote_open_detail').click ->
#    $('i', this).toggleClass 'fa-angle-right'
#    $('i', this).toggleClass 'fa-angle-left'
#    $('.item_expandable').not($(this).parents()).removeClass 'opened'
#    $(this).parents('.item_expandable').toggleClass 'opened'
#    return
#
#
#
## голосование за пост
#@vote_buttons = ->
#  this.vote_post = ->
#    project_id = $(this).data('project')
#    post_id = $(this).data('id')
#    stage = $(this).data('stage')
#    status = $(this).data('status')
#    if project_id and post_id and stage and status
#      $.ajax
#        url: "/project/#{project_id}/#{stage}/posts/#{post_id}/vote"
#        type: "put"
#        dataType: "script"
#        data:
#          status: status
#
#  this.vote_plan = ->
#    project_id = $(this).data('project')
#    post_id = $(this).data('id')
#    type_vote = $(this).data('type-vote')
#    status = $(this).data('status')
#    if project_id and post_id and type_vote and status
#      $.ajax
#        url: "/project/#{project_id}/plan/posts/#{post_id}/vote"
#        type: "put"
#        dataType: "script"
#        data:
#          type_vote: type_vote
#          status: status
#
#  $('.vote_controls').on('click', '.vote_button', this.vote_post)
#  $('.rate_buttons').on('click', '.btn_plan_vote', this.vote_plan)