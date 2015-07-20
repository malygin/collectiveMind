
@save_plan_post = (input_id) ->
  $('#plan_post_tasks_gant').val(JSON.stringify(document.ge.saveProject(), null, 2))
  $('#plan_post_novation_id').val($('#list_novations .active').attr('data-id'))
  $('input#' + input_id).click()
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

@init_cabinet = ->
  # Открывает и закрывает стикеры в кабинете
  $('.open_sticker, .sticker_close').click ->
    $($(this).attr('data-for')).toggle()

  ### Стадия сбора идей ###

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

  #  табы в форме для идей в пакетах переключалка
  $('#tabs_form_navation a').click (e) ->
    $('#tabs_form_navation a button.active').removeClass 'active'
    $(this).children('button').addClass 'active'




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


