@start_play = ->
  $('#player-container').tubeplayer
    width: 600
    height: 450
    allowFullScreen: 'true'
    initialVideo: '8fs6U3MdEpE'
    preferredQuality: 'default'
    showControls: 0
    modestbranding: false
    onPlayerEnded: ->
      $('#player-container').tubeplayer 'destroy'
      $('#play_video').remove()
      $('#movie_watched').click()
      $('#concept-main').show()
      $('#concept-comments-main').show()
      return
  $('#play_video').on 'click', ->
    $('#player-container').tubeplayer 'play'
    return
