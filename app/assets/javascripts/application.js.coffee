# only used

#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.autosize
#= require history_jquery

#= require bootstrap.min

#= require utils
#= require plugins
#= require comments
#= require votes

# from yan's markup
#= require jquery.magnific-popup.min
#= require owl.carousel.min
#= require respond.min
#= require html5shiv
#= require excanvas
#= require jquery.knob
#= require waypoints.min
#= require jquery.contenthover.min
#= require perfect-scrollbar.jquery.min
#= require dropdowns-enhancement

#= require isotope.pkgd.min
#= require underscore
#= require_tree ./templates
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require discontent/discontents
#= require concept/concepts
#= require novation/novations

#= require custom_ready

# GANTT
#= require gantt/date
#= require gantt/ganttDrawer
#= require gantt/ganttGridEditor
#= require gantt/ganttMaster
#= require gantt/ganttTask
#= require gantt/ganttUtilities
#= require gantt/i18nJs
#= require gantt/jquery.dateField
#= require gantt/jquery.JST
#= require gantt/jquery.livequery.min
#= require gantt/jquery.browser.min
#= require gantt/jquery.timers
#= require gantt/platform


$ ->
  start_vote()

  vote_scripts()

  comments_feed()

  search()

  expert_news()

  parse_my_journal_links()

  check_and_push()

  show_comments_hover()

  activate_perfect_scrollbar()

  post_colored_stripes()

  colors_discontents()

  comments_expandable_column()

  $('.avatar_icon').click ->
    $('.avatar_icon').removeClass 'active'
    $(this).addClass 'active'

  $('.with_arrow').click ->
    $(this).find('i.collapse_arrow').toggleClass 'fa-rotate-90'
    if $(this).find('i.collapse_arrow').hasClass('fa-rotate-90')
      $(this).find('i.collapse_arrow').attr('title', 'Свернуть')
    else
      $(this).find('i.collapse_arrow').attr('title', 'Развернуть')
    return

  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $("form#auth-form1").bind "ajax:success", (e, data, status, xhr) ->
    $('#error_explanation').html 'Авторизация успешна, грузим список доступных процедур'
    location.reload()

  $("form#auth-form1").bind "ajax:error", (e, data, status, xhr) ->
    $('#error_explanation').html data.responseText

  # аутосайз полей в кабинете
  $('#cabinet_form textarea').not('.without_autosize').autosize()

  # Используется в кабинете на стадии несовершенств, во вспомогательной технике
  $('.open-popup').each ->
    stageNum = $(this).attr('data-placement')
    popupNum = $(this).attr('data-target')
    src = '#popup-' + stageNum + '-' + popupNum
    $(this).magnificPopup
      type: 'inline'
      items: [{
        src: src
        type: 'inline'
      }]
      callbacks:
        open: ->
          me_id = $.magnificPopup.instance['items'][0]['src']
          pop_h = $('.modal_content', me_id).height()
          $('.modal_content', me_id).css
            'height': pop_h + 'px'
            'overflow': 'hidden'
          return
        close: ->
          return
    return

  ### slide panel 3rd stage ###

  $('#opener').on 'click', ->
    panel = $('#slide-panel')
    if panel.hasClass('visible')
      panel.removeClass('visible').animate 'margin-left': '-400px'
    else
      panel.addClass('visible').animate 'margin-left': '0px'

  ### sort button active ###
  # выделение кнопок сортировки
  $('.sort_btn').click ->
    $('.sort_btn').removeClass 'active'
    $(this).addClass 'active'
    return

  # Открывает и закрывает стикеры в кабинете
  $('.open_sticker').click ->
    stick_id = $(this).attr('data-for')
    $(stick_id).show()
    return
  $('.sticker_close').click ->
    stick_id = $(this).attr('data-for')
    $(stick_id).hide()
    return

  $('.with_plus').click ->
    $(this).find('i.collapse_plus').toggleClass('fa-plus').toggleClass('fa-minus')
    return

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
        return
      return


# @todo ниже можно добавлять только функции! для начальной инициализации блок выше!

@save_plan_post = (input_id) ->
  $('#plan_post_tasks_gant').val(JSON.stringify(document.ge.saveProject(), null, 2))
  $('#plan_post_novation_id').val($('#list_novations .active').attr('data-id'))
  $('input#' + input_id).click()
  return


