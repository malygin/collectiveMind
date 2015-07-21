
@save_plan_post = (input_id) ->
  $('#plan_post_tasks_gant').val(JSON.stringify(document.ge.saveProject(), null, 2))
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




@init_cabinet = ->
  # Открывает и закрывает стикеры в кабинете
  $('.open_sticker, .sticker_close').click ->
    $($(this).attr('data-for')).toggle()

  # checking ideas and discontents
  checking_items_for_cabinet()

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
  #  copy checked items to left panel in novation form
  $('#select_concept').click ->
    $.magnificPopup.open
      items: src: '#popup-cabinet4-1'
      type: 'inline'
      callbacks:
        close: ->
          its = $('.checked_items a').map(->
            '<p>'+$.trim $(this).text()+'</p>'
          ).get()
          $('.selected_concepts').html(its)


  # GANTT
  if $('#gantEditorTemplates').length > 0
    @ge = new GanttMaster()
    @ge.init($("#workSpace"))
    ret = JSON.parse($("#ta").val())
    unless ret == null
      offset = (new Date).getTime() - ret.tasks[0].start
      i = 0
      while i < ret.tasks.length
        ret.tasks[i].start = ret.tasks[i].start + offset
        i++;
      @ge.loadProject(ret);

  # Открытие "Добавления задач" в кабинете проектов
  $('#bottom-opener').on 'click', ->
    $('#plan_buttons button').toggleClass 'disabled'
    panel = $('#bottom-panel')
    if panel.hasClass('visible')
      panel.removeClass('visible').animate 'top': '100%'
      $(this).toggleClass 'fa-rotate-180'
    else
      offset = $('.bottom_panel_stop').offset()
      marg_offset = $('.bottom_fix .cont_heading').innerHeight()
      panel.addClass('visible').animate 'top': offset.top + marg_offset + 'px'
      $(this).toggleClass 'fa-rotate-180'
    false

  $('a.scroll_tab').on 'click', (e) ->
    href = $(this).attr('href')
    $('.tab_cont5').animate { scrollTop: 0 }, 'slow'
    e.preventDefault()






  $('button#to_publish_plan').click ->
    save_plan_post('save_plan_post_published')
  $('button#to_save_plan').click ->
    save_plan_post('save_plan_post')

  if $('#list_novations').length > 0
    $('#ul_novations').on 'click', '.open_novation', (event) ->
      $('#selected_novation').text($(this).text()).removeClass('hidden')
      $('#selected_novation_main_form').text($(this).text())
      $('#select_novation').text('Выбранный пакет:')
      $('#list_novations').find($(this).find('a').attr('href')).find('.novation_attribute').each ->
        $('#plan_post_novations textarea[id="plan_post_novation_' + $(this).attr('data-attribute') + '"]').text($.trim($(this).text()))


