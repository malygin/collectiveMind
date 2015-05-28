@first_stage_slider = ->
  slider = $("#first-stage-slider")
  project_id = slider.data("project")
  if project_id
    $.ajax
      url: "/project/#{project_id}/collect_info/posts/render_slider"
      type: "get"
      dataType: "script"


@selectize = ->
  $select = $("#selectize_for_discontents").selectize
    labelField: "show_content"
    valueField: "id"
    sortField: "show_content"
    searchField: "show_content"
    create: false
    hideSelected: true
    onChange: (item) ->
      optsel = $(".option_for_selectize")
      project_id = parseInt(optsel.attr('data-project'))
      id = parseInt(optsel.attr('data-post'))
      stage = optsel.attr('data-stage')
      if stage == "discontent"
        select_discontent_for_union(project_id,id)
      else if stage == "concept"
        select_discontent_for_concept(project_id)
      selectize = $select[0].selectize
      selectize.removeOption(item)
      selectize.refreshOptions()
      selectize.close()
    render:
      item: (item, escape) ->
        short_item = item.show_content.split('<br/>')[0].replace('<b> что: </b>', '')
        return '<div>'+short_item+'</div>'
      option: (item, escape) ->
        return '<div>'+item.show_content+'</div>'


@filterable = ->
  this.icheck_date = ->
    $('#date_begin').val('')
    $('#date_end').val('')

  this.icheck_enable = ->
    $('#by_create,#by_update,#event_content_all').iCheck('uncheck').iCheck('enable')

  this.icheck_disable = ->
    $('#by_create,#by_update,#event_content_all').iCheck('uncheck').iCheck('disable')

  this.send_filter = ->
    form = $(this).closest('form')
    sendButton = form.find('.send_filter')
    sendButton.click()

  this.load_aspect = (e) ->
    e.preventDefault()
    project = $(this).data('project')
    aspect = $(this).data('aspect')
    $('#tab_aspect_posts div.discontent-block').fadeOut();
    $("#tab_aspect_posts div[class~='aspect_#{aspect}']").fadeIn();

#    if project and aspect
#      $.ajax
#        url: "/project/#{project}/discontent/posts"
#        type: "get"
#        dataType: "script"
#        data:
#          asp: aspect

  this.filter_aspects = (e) ->
    e.preventDefault()
    project = $(this).data('project')
    aspect = $(this).data('aspect')
    color_aspect = $(this).find('.fa-stop').css('color')
    text_aspect = $(this).text()
    $('.select-aspect').html('<i class="fa fa-stop" style="color:' + color_aspect + '"></i>' + text_aspect + '<span class="caret"></span>');
    $('#tab_aspect_posts div.discontent-block').fadeOut();
    $("#tab_aspect_posts div[class~='aspect_#{aspect}']").fadeIn();

  this.filter_discontents = (e) ->
    e.preventDefault()
    project = $(this).data('project')
    discontent = $(this).data('discontent')
    $('#tab_concept_posts div.concept-block').fadeOut();
    $("#tab_concept_posts div[class~='discontent_#{discontent}']").fadeIn();

  this.show_all_aspects = (e) ->
    e.preventDefault()
    $('.select-aspect').html('Выберите аспект <span class="caret"></span>');
#    $('#tab_aspect_posts div.discontent-block').fadeOut();
    $("#tab_aspect_posts div[class^='aspect_']").fadeIn();

#  $('form.filter_news').on('ifChecked', 'input.iCheck#date_all', this.icheck_date)
#  $('form.filter_news').on('ifChecked', 'input.iCheck#by_content', this.icheck_enable)
#  $('form.filter_news').on('ifUnchecked', 'input.iCheck#by_content', this.icheck_disable)

#  $('form.filter_discontents').on('change', 'input:radio', this.send_filter)
#  $('.tabs-discontents').on('click', "li button[id^='link_aspect_']", this.load_aspect)
#  $('.index-of-aspects').on('click', "li[id^='button_aspect_']", this.filter_aspects)
#  $('.index-of-discontents').on('click', "button[id^='button_discontent_']", this.filter_discontents)

#  $('.sort-block').on('click', ".sort-all", this.show_all_aspects)

@sorterable = ->
  SORTER = {}
  SORTER.sort = (which, type, dir) ->
    SORTER.dir = (if (dir is "desc") then -1 else 1)
    $(which).each ->
      # Find the list items and sort them
      sorted = $(this).find("> div").sort((a, b) ->
        if type == "date"
          (if parseFloat($(a).attr('data-date')) > parseFloat($(b).attr('data-date')) then SORTER.dir else -SORTER.dir)
        else if type == "rate"
          (if parseFloat($(a).attr('data-rate')) > parseFloat($(b).attr('data-rate')) then SORTER.dir else -SORTER.dir)
        else 0
      )
      $(this).append sorted

  this.sorter_discontents = (e) ->
    e.preventDefault()
    type = $(this).data('type')
    data_desc = $(this).attr('data-desc')
    if data_desc == "1" then desc = "desc" else desc = ""
    if data_desc == "1" then num = "-1" else num = "1"
    $(this).attr("data-desc","#{num}")
    SORTER.sort "#tab_aspect_posts", type, desc


#  $('.sort-block').on('click', ".sort-date,.sort-rate", this.sorter_discontents)

#@todo analytics
@exampleData = ->
  project_id = $('#nvd3_project').attr("data-project")
  stage = $('#nvd3_project').attr("data-stage")
  if project_id
    jqXHR = $.ajax(
      url: "/project/#{project_id}/graf_data"
      type: "get"
      data:
        data_stage: stage
      dataType: "json"
      async: false
    );
    return jqXHR.responseJSON;


#@todo history js
@history_click = (el)->
  state =
    title: el.getAttribute("title")
    url: el.getAttribute("href", 2)
  history.pushState state, state.title, state.url

@history_change = (link)->
  state =
    title: "Massdecision"
    url: link
  history.pushState state, state.title, state.url


# @todo autocomplete
@autocomplete_initialized = ->
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return


@activate_htmleditor = ->
  tinyMCE.init
    selector: "textarea.tinymce"
    language: "ru"
    plugins:
      ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
       "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
       "save table contextmenu directionality emoticons template paste textcolor"]
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons"
#    setup: (ed) ->
#      ed.on "init", (ed) ->
#        tinyMCE.get(ed.target.id).show()

@сommand_htmleditor = (сommand, id) ->
  #tinyMCE.get('some-textarea').show();
  if сommand == 'remove'
    tinymce.EditorManager.execCommand('mceRemoveEditor', false, id);
  else if сommand == 'add'
    tinymce.EditorManager.execCommand('mceAddEditor', false, id);

# @todo sortable for knowbase
$('#sortable').sortable update: (event, ui) ->
  order = {}
  $("li", this).each (index) ->
    if parseInt($(this).attr('stage')) != (index + 1)
      order[$(this).attr('id')] = index + 1
  $.ajax
    url: "/project/1/knowbase/posts/sortable_save"
    type: "post"
    data:
      sortable: order

# @todo popover-tooltip for plan_posts
$.fn.extend popoverClosable: (options) ->
  defaults =
    template: "<div class=\"popover popover-concept\"><div class=\"arrow\"></div><div class=\"popover-header\"><button type=\"button\" class=\"close\" style=\"font-size:30px;color:white;\" data-dismiss=\"popover\" aria-hidden=\"true\">&times;</button><h3 class=\"popover-title popover-concept-title\"></h3></div><div class=\"popover-content\"></div></div>"
  options = $.extend({}, defaults, options)
  $popover_togglers = this
  $popover_togglers.popover options
  $popover_togglers.on "click", (e) ->
    e.preventDefault()
    $popover_togglers.not(this).popover "hide"
    $('.popover').css 'display', 'none'

  $("html body").on "click", "[data-dismiss=\"popover\"]", (e) ->
    $popover_togglers.popover "hide"
    $('.popover').css 'display', 'none'

# @todo wizard for concept_posts
#@activate_wizard= ->
#  $("#wizard").bootstrapWizard onTabShow: (tab, navigation, index) ->
#    $total = navigation.find("li").length
#    $current = index + 1
#    $percent = ($current / $total) * 100
#    $wizard = $("#wizard")
#    $wizard.find(".progress-bar").css width: $percent + "%"
#    #$('#option_for_wizard_tab').attr("data-tab","#{$current}")
#    go_string = 'Перейти к описанию'
#    go_string2 = 'Перейти к добавлению'
#    names_blocks = ['Идеи','Функционирования','Нежелательных побочных эффектов','Контроля','Целесообразности','Решаемых несовершенств']
#    if $current >= $total
#      $wizard.find(".pager .next").hide()
#      $('#form_save').show()
#    else
#      if $current == 1
#        $wizard.find(".pager .previous").hide()
#        $wizard.find(".pager .next .btn").html(go_string + " " + names_blocks[$current - 1] + " <i class=\"fa fa-caret-right\"></i>")
#        $('#form_save').hide()
#      else if $current in [2,3,4,5,6]
#        if $current == 6 then go_string = go_string2
#        $wizard.find(".pager .previous").show()
#        $wizard.find(".pager .next .btn").html(go_string + " " + names_blocks[$current - 1] + " <i class=\"fa fa-caret-right\"></i>")
#        $('#form_save').show()
#      else
#        $wizard.find(".pager .previous").show()
#        $wizard.find(".pager .next .btn").html('Далее <i class="fa fa-caret-right"></i>')
#        $('#form_save').show()
#      $wizard.find(".pager .next").show()
#    scrollTo(0,0)

# @todo datepicker for plan posts

@activate_datepicker = ->
  $date_begin = $("#plan_post_stage_date_begin")
  $date_end = $("#plan_post_stage_date_end")

  $date_begin.datepicker("refresh")
  $date_end.datepicker("refresh")

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  $date_begin.datepicker("setStartDate", now);
  $date_end.datepicker("setStartDate", now);

  checkin = $date_begin.datepicker(
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    $date_end.datepicker("setStartDate", newDate)
    if $date_end.val() == ''
      $date_end.datepicker("setDate", newDate)
    else
      if ev.date.valueOf() > Date.parse($date_end.val())
        newDate.setDate newDate.getDate() + 1
        $date_end.datepicker("setDate", newDate)
        $date_end[0].focus()
    checkin.hide()
  ).data("datepicker")
  checkout = $date_end.datepicker(
  ).on("changeDate", (ev) ->
    checkout.hide()
  ).data("datepicker")

@activate_datepicker_action = (date_begin, date_end)->
  $date_begin_action = $("#date_begin_action")
  $date_end_action = $("#date_end_action")

  $date_begin_action.datepicker("refresh")
  $date_end_action.datepicker("refresh")

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  if date_begin and date_end
    $date_begin_action.datepicker("setStartDate", new Date(Date.parse(date_begin)));
    $date_begin_action.datepicker("setEndDate", new Date(Date.parse(date_end)));
    $date_end_action.datepicker("setStartDate", new Date(Date.parse(date_begin)));
    $date_end_action.datepicker("setEndDate", new Date(Date.parse(date_end)));
  else
    $date_begin_action.datepicker("setStartDate", now);
    $date_end_action.datepicker("setStartDate", now);

  checkin = $date_begin_action.datepicker(
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    $date_end_action.datepicker("setStartDate", newDate)
    if $date_end_action.val() == ''
      $date_end_action.datepicker("setDate", newDate)
    else
      if ev.date.valueOf() > Date.parse($date_end_action.val())
        newDate.setDate newDate.getDate() + 1
        $date_end_action.datepicker("setDate", newDate)
        $date_end_action[0].focus()
    checkin.hide()
  ).data("datepicker")
  checkout = $date_end_action.datepicker(
  ).on("changeDate", (ev) ->
    checkout.hide()
  ).data("datepicker")