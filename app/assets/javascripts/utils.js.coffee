@search = ->
  this.search_users = ->
    project_id = $('#search_users_project').attr("data-project")
    code_user = $('#search_users_project').attr("data-code")
    val = this.value
    if project_id and val
      $.ajax
        url: "/project/#{project_id}/users/search"
        type: "get"
        data:
          search_users_text: val
          code: code_user

  $('.search_text').on('change', 'input#search_users_text', this.search_users)

# @todo обновление таблицы и списка
$('#PlanTabs li#second a').on "click", (e) ->
  unless $('#PlanTabs li#second').prop("class") == 'disabled'
    $('#spinner_tab2').show()
  render_table('edit')
$('#PlanTabs li#third a').on "click", (e) ->
  unless $('#PlanTabs li#third').prop("class") == 'disabled'
    $('#spinner_tab3').show()
  render_concept_side()

$('#PlanTabsShow li#second a').on "click", (e) ->
  $('#spinner_tab2').show()
  render_table('show')
$('#PlanTabsShow li#third a').on "click", (e) ->
  $('#spinner_tab3').show()
  render_concept_side()

@post_form = ->
  this.activate_button = ->
    form = $(this).closest('form');
    sendButton = form.find('.send-post')
    if (this.value? and this.value.length > 1)
      sendButton.removeClass('disabled')
    else
      sendButton.addClass('disabled')

  $('.form-new-post').on('keyup', 'textarea.post-textarea', this.activate_button)
  $('#form_for_group_discontent').on('keyup', 'textarea.post-textarea', this.activate_button)


@estimate_stage = ->
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

  this.color_select = ->
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

  $('.form-new-estimate').on('change', 'select.estimate_select', this.color_select)


@remove_block = (el)->
  $('#' + el).remove()


@sidebar_for_small_screen = ->
  sidebarHeight = 0;
  $sidebar = $("#sidebar")
  $sidebar.on "show.bs.collapse", (e) ->
    e.target is this and $sidebar.addClass("open") and $sidebar.removeClass('nav-collapse')
    if $("#sidebar").height() > 0
      sidebarHeight = $("#sidebar").height()
    $(".content").css "margin-top", sidebarHeight + 30

  $sidebar.on "hide.bs.collapse", (e) ->
    if e.target is this
      $sidebar.removeClass "open"
      $sidebar.addClass('nav-collapse')
      $(".content").css "margin-top", ""


# @todo work with comment form
@reset_child_comment_form = (comment)->
  $('#child_comments_form_' + comment).empty()

# @todo work with comment on life_tape posts
@select_for_aspects_comments = (el, project, post)->
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
@reset_post_note_form = (post, type)->
  $('#note_for_post_' + post + '_' + type).remove();

############################################
# @todo work with discontent posts and groups

@select_discontent_for_union = (project, id)->
  sel = $('#selectize_for_discontents :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/discontent/posts/#{id}/add_union"
      type: "put"
      data:
        post_id: sel.val()

@activate_add_aspects = ->
  $('#select_for_aspects').on 'change', ->
    val = this.value
    text = $(this).find('option:selected').text()
    $(this).find('option:selected').remove()
    func = "'#{val}','#{text}'"
    $('#add_post_aspects').append('<div id="aspect_' + val + '" style="display:none;height:0;"><input type="hidden" name="discontent_post_aspects[]" value="' + val + '"/><span class="glyphicon glyphicon-remove text-danger pull-left" onclick="remove_discontent_aspect(' + func + ');" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span id="' + val + '" class="span_aspect label label-t">' + text + '</span></br></div>')
    $('#aspect_' + val).css('display', 'block').animate({height: 20, opacity: 1}, 500).effect("highlight",
      {color: '#f5cecd'}, 500)

@remove_discontent_aspect = (val, text)->
  $('#aspect_' + val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_for_aspects').append(new Option(text, val))

@remove_discontent_post = (val)->
  $('#post_' + val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())

@select_for_discontents_group = (el, project, post)->
  project_id = project
  dispost_id = post
  group_id = $(el).val()
  if group_id != '' and dispost_id != ''
    $.ajax
      url: "/project/#{project_id}/discontent/posts/#{dispost_id}/union_group"
      type: "put"
      data:
        group_id: group_id

###############################################
# @todo work with concept posts

@select_discontent_for_concept = (project)->
  sel = $('#selectize_for_discontents :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/concept/posts/add_dispost"
      type: "post"
      data:
        dispost_id: sel.val()
        remove_able: 1

#@add_new_resource_to_concept = (field, field2, project)->
#  position = parseInt($('#resources_' + field + ' .main_resources').last().attr('position'))
#  if not position then position = 1 else position += 1
#  $('#resources_' + field).append("<div class=\"main_resources\" id=\"main_#{field}_#{position}\" position=\"#{position}\"><div class=\"col-md-8\">" + "<span role=\"status\" aria-live=\"polite\" class=\"ui-helper-hidden-accessible\"></span>" + "<input class=\"form-control autocomplete ui-autocomplete-input\" data-autocomplete=\"/project/#{project}/autocomplete_concept_post_resource_concept_posts\" id=\"concept_post_resource\" min-length=\"0\" name=\"resor[][name]\" placeholder=\"Введите свой ресурс или выберите из списка\" type=\"text\" autocomplete=\"off\"><input name=\"resor[][type_res]\" type=\"hidden\" value=\"#{field}\">" + "</div><div class=\"col-md-4\"><div class=\"pull-right\"><button class=\"btn btn-warning\" id=\"desc_to_res\" onclick=\"$(this).parent().parent().parent().find('.desc_resource').show();\" title=\"Добавить описание\" type=\"button\"><i class=\"fa fa-edit\"></i>Описание</button><button class=\"btn btn-success\" id=\"plus_mean\" onclick=\"return add_new_mean_to_resource(this,'#{field2}',#{project});\" title=\"Добавить средство\" type=\"button\">" + "<i class=\"fa fa-plus\"></i>Средство</button><button class=\"btn btn-danger\" id=\"destroy_res\" onclick=\"$(this).parent().parent().parent().remove();\" title=\"Удалить ресурс\" type=\"button\">" + "<i class=\"fa fa-trash-o\"></i>Удалить</button></div></div><br><br><div class=\"desc_resource\" id=\"desc_#{field}_#{position}\" position=\"#{position}\" style=\"display:none;\">" + "<textarea class=\"form-control\" id=\"res\" name=\"resor[][desc]\" placeholder=\"Пояснение к ресурсу\" style=\"overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;\"></textarea>" + "</div><div class=\"col-md-offset-1 col-md-11 means_to_resource\" id=\"means_#{field2}_#{position}\"></div></div>");
#  autocomplete_initialized()
#  $('textarea').autosize()
#
#@add_new_mean_to_resource = (el, field, project)->
#  position = $(el).parent().parent().parent().attr('position')
#  $('#means_' + field + '_' + position).append("<br><div class=\"main_means\" id=\"main_#{field}_#{position}\" position=\"#{position}\"><div class=\"col-md-8\">" + "<span role=\"status\" aria-live=\"polite\" class=\"ui-helper-hidden-accessible\"></span>" + "<input class=\"form-control autocomplete ui-autocomplete-input\" data-autocomplete=\"/project/#{project}/autocomplete_concept_post_mean_concept_posts\" id=\"res\" min-length=\"0\" name=\"resor[][means][][name]\" placeholder=\"Введите свой ресурс или выберите из списка\" type=\"text\" autocomplete=\"off\"><input name=\"resor[][means][][type_res]\" type=\"hidden\" value=\"#{field}\">" + "</div><div class=\"col-md-4\"><div class=\"pull-right\"><button class=\"btn btn-warning\" id=\"desc_to_res\" onclick=\"$(this).parent().parent().parent().find('.desc_mean').show();\" title=\"Добавить описание\" type=\"button\"><i class=\"fa fa-edit\"></i>Описание</button><button class=\"btn btn-danger\" id=\"destroy_res\" onclick=\"$(this).parent().parent().parent().remove();\" title=\"Удалить ресурс\" type=\"button\">" + "<i class=\"fa fa-trash-o\"></i>Удалить</button></div></div><br><br><div class=\"desc_mean\" id=\"desc_#{field}_#{position}\" position=\"#{position}\" style=\"display:none;\">" + "<textarea class=\"form-control\" id=\"res\" name=\"resor[][means][][desc]\" placeholder=\"Пояснение к ресурсу\" style=\"overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;\"></textarea><br></div></div>");
#  autocomplete_initialized()
#  $('textarea').autosize()

##############################################
# @todo work with plan posts

@scroll_to_elem = (el)->
  $(".modal").on "shown.bs.modal", ->
    if $("#" + el)
      pos = $("#" + el).offset().top
      $(".modal").animate {
        scrollTop: pos
      }, 500

#@add_new_resource_to_plan = (field, project)->
#  $('#resources_' + field).append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod" data-autocomplete="/project/' + project + '/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_' + field + '[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_' + field + '[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
#  autocomplete_initialized()

@add_new_action_resource_to_plan = (project)->
  $('#action_resources').append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod2" data-autocomplete="/project/' + project + '/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_action[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_action[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  autocomplete_initialized()

@plan_select_concept = (el)->
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

@save_last_concept = ->
  last_id = $("#option_for_render_old_concept_side").attr('concept')
  if last_id != ''
    $("#li_concept_#{last_id} a").append('<i class="color-green fa fa-save" style="opacity:0;"></i>')
    $("#li_concept_#{last_id} a i").animate {
      opacity: 1
    }, "slow", ->
      $(this).animate {
        opacity: 0
      }, "slow", ->
        $(this).remove()

@save_last_concept_tabs = ->
  $("#third a").append('<i class="color-green fa fa-save" style="opacity:0;"></i>')
  $("#third a i").animate {
    opacity: 1
  }, "slow", ->
    $(this).animate {
      opacity: 0
    }, "slow", ->
      $(this).remove()

@get_concept_save = (new_concept)->
  $('#render_new_concept_side').html('<div id="option_for_render_new_concept_side" concept="' + new_concept + '"></div>')
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

@render_table = (type)->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_table"
      type: "put"
      data:
        render_type: type

@render_concept_side = ->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_concept_side"
      type: "put"

@remove_aspect_concept = (val, text)->
  $('#concept_aspect_' + val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_concept').append('<option id="option_' + val + '" value="' + val + '">' + text + '</option>')

@remove_plan_concept = (el, cp)->
  $(el).parent().parent().remove()
  $("#asp_" + cp).remove()

@render_concept_collapse = (post, concept)->
  if post != '' and concept != ''
    con_id = $("#collapse_plus_concept_" + post + "_" + concept).attr('id')
  if post != '' and concept == ''
    con_id = $("#collapse_dis_concept_" + post).attr('id')
  if post == '' and concept != ''
    con_id = $("#collapse_plus_concept_" + concept).attr('id')
  if typeof con_id is 'undefined'
    return false
  else
    return true


##################################

# @todo users checks
@user_check_field = (el, check_field)->
  optsel = $("#option_for_check_field")
  project_id = parseInt(optsel.attr('project'))
  table_name = optsel.attr('table_name')
  if ( $(el).is(":checked") )
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
