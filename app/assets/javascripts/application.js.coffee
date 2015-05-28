# используемые

#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.ui.autocomplete
#= require jquery.autosize
#= require history_jquery
#= require jquery.tube.min

#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require velocity.min
#= require velocity.ui.min
#= require selectize
#= require tinymce

#= require websocket_rails/main
#= require messenger/messenger.min
#= require jquery.ui.chatbox

#= require utils
#= require plugins
#= require comments
#= require resources

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


#GANTT
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

  start_play()

  comments_feed()

  selectize()

  search()
  post_form()

  activate_htmleditor()
  autocomplete_initialized()
  activate_add_aspects()

  expert_news()

  vote_buttons()

  parse_my_journal_links()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

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

  show_comments_hover()
  activate_perfect_scrollbar()
  post_colored_stripes()
  colors_discontents()
  comments_expandable_column()
  #  vote_scripts()

  ### sort button active ###
  # выделение кнопок сортировки
  $('.sort_btn').click ->
    $('.sort_btn').removeClass 'active'
    $(this).addClass 'active'
    return

  # просмотр несовершенства в голосовании
  $('.vote_open_detail_imperf').click ->
    $('i', this).toggleClass 'fa-angle-right'
    $('i', this).toggleClass 'fa-angle-left'
    $('.item_expandable_imperf').not($(this).parents('.vote_item').find('.item_expandable_imperf')).removeClass 'opened'
    $(this).parents('.vote_item').find('.item_expandable_imperf').toggleClass 'opened'

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

@save_plan_post = (input_id) ->
  $('#plan_post_tasks_gant').val(JSON.stringify(document.ge.saveProject(), null, 2))
  $('#plan_post_novation_id').val($('#list_novations .active').attr('data-id'))
  $('input#' + input_id).click()
  return

#@save_plan = ->
#  this.save_plan_post = (input_id) ->
#    $('#plan_post_tasks_gant').val(JSON.stringify(document.ge.saveProject(), null, 2))
#    $('#plan_post_novation_id').val($('#list_novations .active').attr('data-id'))
#    $('input#' + input_id).click()
#
#  $('body').on('click', 'button#to_publish_plan', this.save_plan_post('save_plan_post_published'))
#  $('body').on('click', 'button#to_save_plan', this.save_plan_post('save_plan_post'))

# временно!!!
# голосование в попапе - прогресс и работа с папками - > упростить
@vote_scripts = ->
  folder_len = {}
  vote_icon_all = 'fa-home'

  count_vote_items = (me) ->
    $('.vote_item_cont', me).length

  pb_stretch = (me, current, over) ->
    vote_perc = (1 - current / over) * 100
    me.css 'width', vote_perc + '%'
    return

  $('[data-vote-poll-role]').each ->
    role = $(this).attr('data-vote-poll-role')
    len = count_vote_items($(this))
    folder_len[role] = len
    $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text len
    return
  pb = $('.vote_progress')
  all_len = folder_len['overall'] = count_vote_items('.all_vote')
  pb_stretch pb, all_len, folder_len['overall']
  $('.vote_button').click ->
    role = $(this).attr('data-vote-role')
    if !$(this).hasClass('voted')
      if $(this).siblings().hasClass('voted')
        prev_role = $(this).siblings('.voted').attr('data-vote-role')
        $(this).siblings('.voted').each ->
          $(this).removeClass 'voted'
          $('.fa', this).removeClass(vote_icon_all).addClass $(this).attr('data-icon-class')
          return
      $(this).addClass 'voted'
      $('.fa', this).removeClass($(this).attr('data-icon-class')).addClass vote_icon_all
      vote_item = $(this).parents('.vote_item_cont').detach()
      $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text ++folder_len[role]
      if prev_role
        $('[data-vote-folder-role = "' + prev_role + '"] > .vote_folder_inn > .vote_counter').text --folder_len[prev_role]
      else
        all_len--
        $('[data-vote-folder-role = "all"] > .vote_folder_inn > .vote_counter').text all_len
        pb_stretch pb, all_len, folder_len['overall']
      $('[data-vote-poll-role = "' + role + '"] .container>.row').append vote_item
    else
      $(this).removeClass 'voted'
      $('.fa', this).removeClass(vote_icon_all).addClass $(this).attr('data-icon-class')
      vote_item = $(this).parents('.vote_item_cont').detach()
      $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text --folder_len[role]
      $('.all_vote>.container>.row').append vote_item
      all_len++
      $('[data-vote-folder-role = "all"] > .vote_folder_inn > .vote_counter').text all_len
      pb_stretch pb, all_len, folder_len['overall']
    item_e = $(this).parents('.item_expandable')
    if item_e.hasClass('opened')
      item_e.removeClass 'opened'
      $(this).siblings('.vote_open_detail').children('i').toggleClass('fa-angle-right').toggleClass 'fa-angle-left'
    return
  $('.vote_open_detail').click ->
    $('i', this).toggleClass 'fa-angle-right'
    $('i', this).toggleClass 'fa-angle-left'
    $('.item_expandable').not($(this).parents()).removeClass 'opened'
    $(this).parents('.item_expandable').toggleClass 'opened'
    return

# @todo ниже ничего не добавлять!!! здесь только функции! для начальной инициализации блок выше!
