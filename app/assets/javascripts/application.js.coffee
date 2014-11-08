#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart
#= require jquery.magnific-popup.min
#= require jquery.autosize
#= require totop/jquery.ui.totop
#= require totop/easing
#= require jquery.icheck

#= require bootstrap/bootstrap.min
#= require bootstrap-colorpicker
#= require datepicker/bootstrap-datepicker
#= require bootstrap3-editable/bootstrap-editable

#= require autocomplete-rails-dev
#= require selectize
#= require liFixar/jquery.liFixar

#= require tinymce
#= require websocket_rails/main
#= require messenger/messenger.min
#= require select2
#= require wizard/jquery.bootstrap.wizard
#= require news
#= require notifications
#= require jquery.ui.chatbox
#= require moderator_chat

# @todo load initialization
sidebarHeight = 0;
$ ->
  notificate_my_journals()
  create_moderator_chat()

  $(".image-popup-vertical-fit").magnificPopup
    type: "image"
    closeOnContentClick: true
    mainClass: "mfp-img-mobile"
    image:
      verticalFit: true

  $("#color").colorpicker().on "changeColor", (ev) ->
    $("#color-holder").css "backgroundColor", ev.color.toHex()

  $(".chzn-select").each ->
    $(this).select2 $(this).data()

  $(".iCheck").iCheck
    checkboxClass: "icheckbox_square-grey"
    radioClass: "iradio_square-grey"

  $sidebar = $("#sidebar")

  $sidebar.on "show.bs.collapse", (e) ->

    e.target is this and $sidebar.addClass("open") and $sidebar.removeClass('nav-collapse')
    if $("#sidebar").height()  > 0
      sidebarHeight =  $("#sidebar").height()
    $(".content").css "margin-top", sidebarHeight + 30

  $sidebar.on "hide.bs.collapse", (e) ->
    if e.target is this
      $sidebar.removeClass "open"
      $sidebar.addClass('nav-collapse')
      $(".content").css "margin-top", ""


  $('textarea.comment-textarea').on 'keyup', ->
    activate_button(this)

  $('.tooltips').tooltip()

  activate_htmleditor()

  activate_wizard()

  $("select.estimate_select").each ->
    switch $(this).val()
      when '1.0'
        color = '#999'
      when '2.0'
        color = '#e5603b'
      when '3.0'
        color = '#fd8605'
      when '4.0'
        color = '#56bc76'
      else
        color = '#999'
    $(this).css 'color', color
    $(this).find("option[value='1.0']").css 'color', '#999'
    $(this).find("option[value='2.0']").css 'color', '#e5603b'
    $(this).find("option[value='3.0']").css 'color', '#fd8605'
    $(this).find("option[value='4.0']").css 'color', '#56bc76'

  $().UItoTop easingType: "easeOutQuart"

  $("#sortable").sortable()

  $("#sortable").disableSelection()

  autocomplete_initialized()

  if ($(window).width() > 1030)
    $('ul.panel-collapse.collapse').removeClass('collapse').addClass('open in')

  $('textarea').autosize()

  $('.liFixar').liFixar()

  $('.userscore').editable()


  $('.carousel').carousel
    interval: 4000,
    pause: "hover"
#    wrap: false

  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

  selectize_discontent()
  selectize_concept()

@selectize_discontent= ->
  $select = $("#selectize_discontent").selectize
    labelField: "show_content"
    valueField: "id"
    sortField: "show_content"
    searchField: "show_content"
    create: false
    hideSelected: true
    onChange: (item) ->
      optsel = $(".option_for_selectize")
      project_id = parseInt(optsel.attr('project'))
      id = parseInt(optsel.attr('post'))
      select_discontent_for_union(project_id,id)
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

@selectize_concept= ->
  $select = $("#selectize_concept").selectize
    labelField: "show_content"
    valueField: "id"
    sortField: "show_content"
    searchField: "show_content"
    create: false
    hideSelected: true
    onChange: (item) ->
      optsel = $(".option_for_selectize")
      project_id = parseInt(optsel.attr('project'))
      id = parseInt(optsel.attr('post'))
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


#search_users
$('#search_users_text').on 'change', ->
  project_id = $('#search_users_project').attr("data-project")
  val=this.value
  if project_id and val
    $.ajax
      url: "/project/#{project_id}/users/search_users"
      type: "get"
      data:
        search_users_text: val

@activate_htmleditor= ->
  tinyMCE.init
    selector: "textarea.tinymce"
    setup: (ed) ->
      ed.on "init", (ed) ->
        tinyMCE.get(ed.target.id).show()

    plugins:
      ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
      "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
      "save table contextmenu directionality emoticons template paste textcolor"]
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons"

# @todo обновление таблицы и списка
$('#PlanTabs li#second a').on "click", (e) ->
  render_table('edit')
$('#PlanTabs li#third a').on "click", (e) ->
  render_concept_side()

$('#PlanTabsShow li#second a').on "click", (e) ->
  render_table('show')
$('#PlanTabsShow li#third a').on "click", (e) ->
  render_concept_side()

###################################
# @todo work with comment buttons
@activate_button = (el)->
  if (el.value? and el.value.length>1)
    $('#send_post').removeClass('disabled')
  else
    $('#send_post').addClass('disabled')

@remove_block = (el)->
  $('#'+el).remove()

@disable_send_button= ->
  $('#send_post').toggleClass('disabled')

@color_button= (el)->
  if $(el).hasClass('active')
    $(el).removeClass('btn-success')
    $(el).addClass('btn-default')
  else
    $(el).removeClass('btn-default')
    $(el).addClass('btn-success')


# @todo work with comment form
@reset_child_comment_form= (comment)->
  $('#child_comments_form_'+comment).empty()
@reset_main_comment_form= (comment)->
  $('#main_comments_form_'+comment).empty()

# @todo work with comment on life_tape posts
@select_for_aspects_comments= (el,project,post)->
  project_id = project
  comment_id = post
  aspect_id = $(el).val()
  if aspect_id != '' and comment_id != ''
    $.ajax
      url: "/project/#{project_id}/life_tape/posts/transfer_comment"
      type: "put"
      data:
        comment_id: comment_id
        aspect_id: aspect_id

# @todo work with notes form
@reset_post_note_form= (post,type)->
  $('#note_for_post_'+post+'_'+type).remove();

############################################
# @todo work with discontent_post and group
@select_discontent_for_union= (project,id)->
  sel = $('#selectize_discontent :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/discontent/posts/#{id}/add_union"
      type: "put"
      data:
        post_id: sel.val()

@activate_add_aspects= ->
  $('#select_for_aspects').on 'change', ->
    val=this.value
    text=$(this).find('option:selected').text()
    $(this).find('option:selected').remove()
    func = "'#{val}','#{text}'"
    $('#add_post_aspects').append('<div id="aspect_'+val+'" style="display:none;height:0;"><input type="hidden" name="discontent_post_aspects[]" value="'+val+'"/><span class="glyphicon glyphicon-remove text-danger pull-left" onclick="remove_discontent_aspect('+func+');" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span id="'+val+'" class="span_aspect label label-t">'+text+'</span></br></div>')
    $('#aspect_'+val).css('display','block').animate({height: 20, opacity:1}, 500).effect("highlight", {color: '#f5cecd'}, 500)

activate_add_aspects()

@remove_discontent_aspect= (val,text)->
  $('#aspect_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_for_aspects').append(new Option(text,val))

@remove_discontent_post= (val)->
  $('#post_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())

@select_for_discontents_group= (el,project,post,type,parent)->
  project_id = project
  dispost_id = post
  parent_post = parent
  group_id = $(el).val()
  if group_id != '' and dispost_id != ''
    $.ajax
      url: "/project/#{project_id}/discontent/posts/#{dispost_id}/union_group"
      type: "put"
      data:
        group_id: group_id
        type_list: type
        parent_post: parent_post

$('#tab_posts li#new a').on 'click', ->
  project_id = $(this).attr("data-project")
  $.ajax
    url: "/project/#{project_id}/discontent/posts/unions"
    type: "get"
    data:
      list_type: 'new_posts'

###############################################
# @todo work with concept_post
@select_discontent_for_concept= (project)->
  sel = $('#selectize_concept :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/concept/posts/add_dispost"
      type: "post"
      data:
        dispost_id: sel.val()
        remove_able: 1

#@add_new_resource_to_concept= (field,project)->
#  $('#resources_'+field).append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/'+project+'/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_'+field+'[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_'+field+'[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
#  autocomplete_initialized()

@add_new_resource_to_concept= (field,field2,project)->
#  field = field.toString();
  position = parseInt($('#resources_'+field+' .main_resources').last().attr('position'))
  if not position then position = 1 else position+=1
  $('#resources_'+field).append("<div class=\"main_resources\" id=\"main_#{field}_#{position}\" position=\"#{position}\"><div class=\"col-md-6\">"+"<span role=\"status\" aria-live=\"polite\" class=\"ui-helper-hidden-accessible\"></span>"+"<input class=\"form-control autocomplete ui-autocomplete-input\" data-autocomplete=\"/project/#{project}/autocomplete_concept_post_resource_concept_posts\" id=\"concept_post_resource\" min-length=\"0\" name=\"resor[][name]\" placeholder=\"Введите свой ресурс или выберите из списка\" type=\"text\" autocomplete=\"off\"><input name=\"resor[][type_res]\" type=\"hidden\" value=\"#{field}\">"+"</div><div class=\"col-md-6\"><div class=\"pull-right\"><button class=\"btn btn-info\" id=\"desc_to_res\" onclick=\"$(this).parent().parent().parent().find('.desc_resource').show();\" title=\"Добавить описание\" type=\"button\"><i class=\"fa fa-edit\"></i></button><button class=\"btn btn-success\" id=\"plus_mean\" onclick=\"return add_new_mean_to_resource(this,'#{field2}',#{project});\" title=\"Добавить средство\" type=\"button\">"+"<i class=\"fa fa-plus\"></i></button><button class=\"btn btn-danger\" id=\"destroy_res\" onclick=\"$(this).parent().parent().parent().remove();\" title=\"Удалить ресурс\" type=\"button\">"+"<i class=\"fa fa-trash-o\"></i></button></div></div><br><br><div class=\"desc_resource\" id=\"desc_#{field}_#{position}\" position=\"#{position}\" style=\"display:none;\">"+"<textarea class=\"form-control\" id=\"res\" name=\"resor[][desc]\" placeholder=\"Пояснение к ресурсу\" style=\"overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;\"></textarea>"+"</div><div class=\"col-md-offset-1 col-md-11 means_to_resource\" id=\"means_#{field2}_#{position}\"></div></div>");
  autocomplete_initialized()
  $('textarea').autosize()

@add_new_mean_to_resource= (el,field,project)->
#  field = field.toString();
  position = $(el).parent().parent().parent().attr('position')
  $('#means_'+field+'_'+position).append("<br><div class=\"main_means\" id=\"main_#{field}_#{position}\" position=\"#{position}\"><div class=\"col-md-8\">"+"<span role=\"status\" aria-live=\"polite\" class=\"ui-helper-hidden-accessible\"></span>"+"<input class=\"form-control autocomplete ui-autocomplete-input\" data-autocomplete=\"/project/#{project}/autocomplete_concept_post_mean_concept_posts\" id=\"res\" min-length=\"0\" name=\"resor[][means][][name]\" placeholder=\"Введите свой ресурс или выберите из списка\" type=\"text\" autocomplete=\"off\"><input name=\"resor[][means][][type_res]\" type=\"hidden\" value=\"#{field}\">"+"</div><div class=\"col-md-4\"><div class=\"pull-right\"><button class=\"btn btn-info\" id=\"desc_to_res\" onclick=\"$(this).parent().parent().parent().find('.desc_mean').show();\" title=\"Добавить описание\" type=\"button\"><i class=\"fa fa-edit\"></i></button><button class=\"btn btn-danger\" id=\"destroy_res\" onclick=\"$(this).parent().parent().parent().remove();\" title=\"Удалить ресурс\" type=\"button\">"+"<i class=\"fa fa-trash-o\"></i></button></div></div><br><br><div class=\"desc_mean\" id=\"desc_#{field}_#{position}\" position=\"#{position}\" style=\"display:none;\">"+"<textarea class=\"form-control\" id=\"res\" name=\"resor[][means][][desc]\" placeholder=\"Пояснение к ресурсу\" style=\"overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;\"></textarea><br></div></div>");
  autocomplete_initialized()
  $('textarea').autosize()

##############################################
# @todo work with plan_post
@scroll_to_elem= (el)->
  $(".modal").on "shown.bs.modal", ->
    if $("#" + el)
      pos = $("#" + el).offset().top
      $(".modal").animate {
        scrollTop: pos
      }, 500

@add_new_resource_to_plan= (field,project)->
  $('#resources_'+field).append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod" data-autocomplete="/project/'+project+'/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_'+field+'[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_'+field+'[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  autocomplete_initialized()

@add_new_action_resource_to_plan= (project)->
  $('#action_resources').append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod2" data-autocomplete="/project/'+project+'/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_action[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_action[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  autocomplete_initialized()

@plan_select_concept= (el)->
  optsel = $("#option_for_select_concept")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  stage_id = parseInt(optsel.attr('stage'))
  concept_id = $(el).val()
  if concept_id is "0"
    return (false)
  if concept_id != ''
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/add_form_for_concept"
      type: "put"
      data:
        concept_id: concept_id
        stage_id: stage_id

@save_last_concept= ->
  last_id = $("#option_for_render_old_concept_side").attr('concept')
  -if last_id != ''
    $("#li_concept_#{last_id} a").append('<i class="color-green fa fa-save" style="opacity:0;"></i>')
    $("#li_concept_#{last_id} a i").animate {
      opacity: 1
    }, "slow",  ->
      $(this).animate {
        opacity: 0
      }, "slow",  ->
        $(this).remove()

@save_last_concept_tabs= ->
  $("#third a").append('<i class="color-green fa fa-save" style="opacity:0;"></i>')
  $("#third a i").animate {
    opacity: 1
  }, "slow",  ->
    $(this).animate {
      opacity: 0
    }, "slow",  ->
      $(this).remove()

@get_concept_save= (new_concept)->
  $('#render_new_concept_side').html('<div id="option_for_render_new_concept_side" concept="'+new_concept+'"></div>')
  if $('#send_post_concept').val()
    $('#send_post_concept').submit()
  else
    optsel = $("#option_for_render_tab")
    project_id = parseInt(optsel.attr('project'))
    post_id = parseInt(optsel.attr('post'))
    if project_id and post_id and new_concept != ''
      $.ajax
        url: "/project/#{project_id}/plan/posts/#{post_id}/get_concept"
        type: "get"
        data:
          con_id: new_concept

@render_table= (type)->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_table"
      type: "put"
      data:
        render_type:type

@render_concept_side= ->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_concept_side"
      type: "put"

@remove_aspect_concept= (val,text)->
  $('#concept_aspect_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_concept').append('<option id="option_'+val+'" value="'+val+'">'+text+'</option>')

@remove_plan_concept= (el,cp)->
  $(el).parent().parent().remove()
  $("#asp_"+cp).remove()

@render_concept_collapse= (post,concept)->
  if post!='' and concept!=''
    con_id = $("#collapse_plus_concept_"+post+"_"+concept).attr('id')
  if post!='' and concept == ''
    con_id = $("#collapse_dis_concept_"+post).attr('id')
  if post =='' and concept != ''
    con_id = $("#collapse_plus_concept_"+concept).attr('id')
  if typeof con_id is 'undefined'
    return false
  else
    return true

###################################
# @todo work with estimate_post
@color_select= (el)->
  switch $(el).val()
    when '1.0'
      color = '#999'
    when '2.0'
      color = '#e5603b'
    when '3.0'
      color = '#fd8605'
    when '4.0'
      color = '#56bc76'
    else
      color = '#999'
  $(el).css 'color', color

##################################
# @todo autocomplete
@autocomplete_initialized= ->
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

# @todo popover-tooltip for plan_posts
$.fn.extend popoverClosable: (options) ->
  defaults = template: "<div class=\"popover popover-concept\"><div class=\"arrow\"></div><div class=\"popover-header\"><button type=\"button\" class=\"close\" style=\"font-size:30px;color:white;\" data-dismiss=\"popover\" aria-hidden=\"true\">&times;</button><h3 class=\"popover-title popover-concept-title\"></h3></div><div class=\"popover-content\"></div></div>"
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

# @todo wizard for plan_posts and other
#$("#wizard").bootstrapWizard onTabShow: (tab, navigation, index) ->
#  $total = navigation.find("li").length
#  $current = index + 1
#  $percent = ($current / $total) * 100
#  $wizard = $("#wizard")
#  $wizard.find(".progress-bar").css width: $percent + "%"
#  if $current >= $total
#    $wizard.find(".pager .next").hide()
#    $wizard.find(".pager .finish").show()
#    $wizard.find(".pager .finish").removeClass "disabled"
#  else
#    $wizard.find(".pager .next").show()
#    $wizard.find(".pager .finish").hide()
#  #  if $current is 1
#  #    $("#send_post_concept").submit()
#  if $current is 2
#    render_table()
#  #    $("#send_post_concept").submit()
#  if $current is 3
#    render_concept_side()

#for other
@activate_wizard= ->
  $("#wizard").bootstrapWizard onTabShow: (tab, navigation, index) ->
    $total = navigation.find("li").length
    $current = index + 1
    $percent = ($current / $total) * 100
    $wizard = $("#wizard")
    $wizard.find(".progress-bar").css width: $percent + "%"
    project_id = $('#option_for_wizard_save').attr("data-project")
    concept_id = $('#option_for_wizard_save').attr("data-post")
    if concept_id and $current == 1
      $('#second a').tab('show')
    if $current == 1
      $('#form_save').hide()
    else
      $('#form_save').show()

    $('#option_for_wizard_tab').attr("data-tab","#{$current}")

    if $current >= $total
      $wizard.find(".pager .next").hide()
    else
      if $current == 1
        $wizard.find(".pager .previous").hide()
        $wizard.find(".pager .next .btn").html('Перейти к описанию Идеи <i class="fa fa-caret-right"></i>')
      else if $current == 2
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Перейти к описанию Функционирования <i class="fa fa-caret-right"></i>')
      else if $current == 3
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Перейти к описанию Нежелательных побочных эффектов <i class="fa fa-caret-right"></i>')
      else if $current == 4
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Перейти к описанию Контроля <i class="fa fa-caret-right"></i>')
      else if $current == 5
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Перейти к описанию Целесообразности <i class="fa fa-caret-right"></i>')
      else if $current == 6
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Перейти к добавлению Решаемых несовершенств <i class="fa fa-caret-right"></i>')
      else
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Далее <i class="fa fa-caret-right"></i>')

      $wizard.find(".pager .next").show()
    scrollTo(0,0)

# @todo users checks
@user_check_field= (el,check_field)->
  optsel = $("#option_for_check_field")
  project_id = parseInt(optsel.attr('project'))
  table_name = optsel.attr('table_name')
  if ( $(el).is( ":checked" ) )
    status = true
  else
    status = false
  if check_field != ''
    $.ajax
      url: "/project/#{project_id}/#{table_name}/posts/check_field"
      type: "get"
      data:
        check_field: check_field
        status: status


$("#date_all").on "ifChecked", (e) ->
  $('#date_begin').val('')
  $('#date_end').val('')

$("#by_content").on "ifChecked", (e) ->
  $('#by_create,#by_update,#event_content_all').iCheck('uncheck').iCheck('enable')

$("#by_content").on "ifUnchecked", (e) ->
  $('#by_create,#by_update,#event_content_all').iCheck('uncheck').iCheck('disable')

# @todo wysihtml5 editor
#@activate_htmleditor= ->
#  @editor = $(".wysihtml5").each (i, elem) ->
#    $(elem).wysihtml5
#      "font-styles": true
#      emphasis: true
#      lists: true
#      html: true
#      link: true
#      image: true
#      color: true
# @todo ckeditor

#@activate_htmleditor= ->
#  data = $(".ckeditor")
#  $.each data, (i) ->
#    CKEDITOR.replace data[i].id
#    return

# @todo sortable for knowbase
$('#sortable').sortable update: (event, ui) ->
  order = {}
  $("li",this).each (index) ->
    if parseInt($(this).attr('stage')) != (index+1)
      order[$(this).attr('id')] = index+1
  $.ajax
    url: "/project/1/knowbase/posts/sortable_save"
    type: "post"
    data:
      sortable: order

# @todo datepicker for plan_posts
@activate_datepicker= ->
  $("#date_begin").datepicker("refresh")
  $("#date_end").datepicker("refresh")

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  $("#date_begin").datepicker("setStartDate", now);
  $("#date_end").datepicker("setStartDate", now);

  checkin = $("#date_begin").datepicker(
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    $("#date_end").datepicker("setStartDate", newDate)
    if $("#date_end").val() == ''
      $("#date_end").datepicker("setDate", newDate)
    else
      if ev.date.valueOf() > Date.parse($("#date_end").val())
        newDate.setDate newDate.getDate() + 1
        $("#date_end").datepicker("setDate", newDate)
        $("#date_end")[0].focus()
    checkin.hide()
  ).data("datepicker")
  checkout = $("#date_end").datepicker(
  ).on("changeDate", (ev) ->
    checkout.hide()
  ).data("datepicker")

@activate_datepicker_action= (date_begin,date_end)->
  $("#date_begin_action").datepicker("refresh")
  $("#date_end_action").datepicker("refresh")

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  if date_begin and date_end
    $("#date_begin_action").datepicker("setStartDate", new Date(Date.parse(date_begin)));
    $("#date_begin_action").datepicker("setEndDate", new Date(Date.parse(date_end)));
    $("#date_end_action").datepicker("setStartDate", new Date(Date.parse(date_begin)));
    $("#date_end_action").datepicker("setEndDate", new Date(Date.parse(date_end)));
  else
    $("#date_begin_action").datepicker("setStartDate", now);
    $("#date_end_action").datepicker("setStartDate", now);

  checkin = $("#date_begin_action").datepicker(
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    $("#date_end_action").datepicker("setStartDate", newDate)
    if $("#date_end_action").val() == ''
      $("#date_end_action").datepicker("setDate", newDate)
    else
      if ev.date.valueOf() > Date.parse($("#date_end_action").val())
        newDate.setDate newDate.getDate() + 1
        $("#date_end_action").datepicker("setDate", newDate)
        $("#date_end_action")[0].focus()
    checkin.hide()
  ).data("datepicker")
  checkout = $("#date_end_action").datepicker(
  ).on("changeDate", (ev) ->
    checkout.hide()
  ).data("datepicker")