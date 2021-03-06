@vote_scripts = ->
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
    vote_item = el.parents('.md_vote_item_cont').detach()
    if stage == 'concept'
      # удаляем описание идеи из правой колонки
      vote_desc = $('#desript_'+post_id).detach()
      # перемещаем пост и описание в конечную папку
      $('[data-vote-poll-role = "' + next_folder_role + '"] .md-vote-container .md_vote_concepts').append vote_item
      $('[data-vote-poll-role = "' + next_folder_role + '"] .md-vote-container .md_vote_desc_concepts').append vote_desc
    else
      # перемещаем пост в конечную папку
      $('[data-vote-poll-role = "' + next_folder_role + '"] .md-vote-container').append vote_item

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
    progress = $('.md_vote_progress')
    all_posts = parseInt(progress.attr('data-progress-all'))
    voted_posts = parseInt(progress.attr('data-progress-voted'))
    if prev_folder_role == 'all'
      ++voted_posts
    else if next_folder_role == 'all'
      --voted_posts
    vote_perc = (voted_posts / all_posts) * 100
    progress.attr('data-progress-voted', voted_posts)
    progress.css 'width', vote_perc + '%'

