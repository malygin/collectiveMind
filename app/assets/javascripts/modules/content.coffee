@init_content = ->
  ### show hint for question on 1st stage  ###
  $('.notice-button').click ->
    $('#hint_question_' + $(this).data('question')).removeClass 'close-notice'

  ### close hint for question on 1st stage  ###
  $('.close-button,.answer-button,.li_aspect').click ->
    $('.hint').addClass 'close-notice'

  ### close notice for question on 1st stage  ###
  $('.answer-button,.li_aspect').click ->
    $('.notice').addClass 'close-notice'






