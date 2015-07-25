### initialize cabinet  ###
@init_cabinet = ->
  projectTaskManagerInit('#workSpace', '#ta')
  # checking ideas and discontents
  checking_items_for_cabinet()

  # Открывает и закрывает стикеры в кабинете
  $('.open_sticker, .sticker_close').click ->
    $($(this).attr('data-for')).toggle()

  ### Стадия сбора идей ###
  # подгрузка несовершенств при клике на аспект в форме добавления идеи
  $('.show_discontents').on "click", (e) ->
    aspect_id = $(this).data('aspect')
    if aspect_id
      $.ajax
        url: "/project/#{project_id}/concept/posts/show_discontents"
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
        url: "/project/#{project_id}/concept/posts/search_discontents"
        type: "put"
        dataType: "script"
        data:
          search_text: val

  ### Стадия сбора пакетов ###

 # for callback after popup in novation cabinet closed
  @updateListOfConceptsAfterPopupClose  = ->
    its = $('.checked_items a').map(->
      '<p>'+$.trim $(this).text()+'</p>'
    ).get()
    $('.selected_concepts').html(its)

  #  copy checked items to left panel in novation form
  $('#select_concept').click ->
    mp = popupInit('#popup-cabinet4-1', callbackOnClose: updateListOfConceptsAfterPopupClose)



  ### Стадия сбора проектов ###
  $('#select_novation').click ->
    popupInit('#popup-cabinet5-1')

  $('#choose_novation').click  ->
    if $('#list_novations').length > 0
      $('#selected_novation_main_form').text('Выбранный пакет:' + $('.open_novation.active a ').text().trim())
      $('#list_novations .active').find('.novation_attribute').each ->
        $('#plan_post_novations textarea[id="plan_post_novation_' + $(this).attr('data-attribute') + '"]').text($.trim($(this).text()))
      @popupClose()

  # Открытие "Добавления задач" в кабинете проектов
  $('#bottom-opener').on 'click', ->
    $('#plan_buttons button').toggleClass 'disabled'
    new_top = if $('#bottom-panel').hasClass('visible')  then '100%' else $('.bottom_panel_stop').offset().top+60
    $('#bottom-panel').animate('top': new_top).toggleClass 'visible'
    $(this).toggleClass 'fa-rotate-180'

  $('button#to_publish_plan').click ->
    save_plan_post('save_plan_post_published')
  $('button#to_save_plan').click ->
    save_plan_post('save_plan_post')










