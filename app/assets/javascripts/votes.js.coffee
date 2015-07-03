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
  this.vote_plan = ->
    project_id = $(this).data('project')
    post_id = $(this).data('id')
    type_vote = $(this).data('type-vote')
    status = $(this).data('status')
    if project_id and post_id and type_vote and status
      $.ajax
        url: "/project/#{project_id}/plan/posts/#{post_id}/vote"
        type: "put"
        dataType: "script"
        data:
          type_vote: type_vote
          status: status

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

    # перемещаем пост (перемещение можно настраивать в зависимоти от этапа - stage)
    vote_move_post(el, next_folder_role)

    # изменяем счетчики
    vote_counter(prev_folder_role, next_folder_role)

    # изменяем прогресс
    vote_progress(prev_folder_role, next_folder_role)

  this.vote_move_post = (el, next_folder_role)->
    post_id = el.data('id')
    stage = el.data('stage')
    # удаляем пост из начальной папки
    vote_item = el.parents('.vote_item_cont').detach()
    if stage == 'concept'
      # удаляем описание идеи из правой колонки
      vote_desc = $('#desript_'+post_id).detach()
      # перемещаем пост и описание в конечную папку
      $('[data-vote-poll-role = "' + next_folder_role + '"] .container .vote_concepts').append vote_item
      $('[data-vote-poll-role = "' + next_folder_role + '"] .container .vote_desc_concepts').append vote_desc
    else
      # перемещаем пост в конечную папку
      $('[data-vote-poll-role = "' + next_folder_role + '"] .container > .row').append vote_item

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

  this.vote_counter = (prev_folder_role, next_folder_role)->
    prev_folder_counter = $('[data-vote-folder-role = "' + prev_folder_role + '"] .vote_counter')
    next_folder_counter = $('[data-vote-folder-role = "' + next_folder_role + '"] .vote_counter')
    prev_folder_counter.html(parseInt(prev_folder_counter.html())-1)
    next_folder_counter.html(parseInt(next_folder_counter.html())+1)

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
  $('.rate_buttons').on('click', '.btn_plan_vote', this.vote_plan)


