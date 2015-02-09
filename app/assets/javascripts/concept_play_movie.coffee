@start_play = ->
  $('#player-container').tubeplayer
    width: $('#play_video').width()
    height: 450
    allowFullScreen: 'true'
    initialVideo: 'YA1S941EdAY'
    preferredQuality: 'default'
    showControls: 0
    modestbranding: false
    onPlayerEnded: ->
      $('#player-container').tubeplayer 'destroy'
      $('#play_video').remove()
      $('#message-before-movie').remove()
      delay = 4000
      $('#message-after-movie').fadeIn('slow').delay(delay - 10).fadeOut('slow')
      $('#movie_watched').click()
      $('#concept-main').delay(delay).fadeIn('slow')
      $('#concept-comments-main').delay(delay).fadeIn('slow')
      return
  $('#play_video').on 'click', ->
    if ($(this).attr('data-stage') == 'play')
      $('#player-container').tubeplayer 'play'
      $(this).text('Поставить на паузу')
      $(this).attr('data-stage', 'pause')
    else
      $('#player-container').tubeplayer 'pause'
      $(this).text('Продолжить просмотр')
      $(this).attr('data-stage', 'play')
    return
