@comments_feed = ->

#  check if url contain anchor
  myLink = document.location.toString();
  if (myLink.match(/comment_(\d+)/))
    $('#comment_content_' + myLink.match(/comment_(\d+)/)[1]).effect("highlight", 3000);
    return false;

  this.edit_comment = (e)->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    form = $('<form accept-charset="UTF-8" action="/project/' + project + '/' + path + '/' + id + '/update_comment" data-remote="true" enctype="multipart/form-data" id="form_edit_comment_' + id + '" method="post"/>')
    form.append('<textarea class="form-control input-transparent" name="content" placeholder="Ваш комментарий" >' + $.trim($('#comment_text_' + id).html()) + '</textarea>')
    form.append('<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"></div>')
    form.append('<input id="life_tape_comment_image" name="image" type="file"><br/>')
    form.append('<button class="edit-cancel btn btn-xs btn-danger" data-id="' + id + '">Отменить</button> | ')
    form.append('<input class="btn btn-xs btn-info"  name="commit"  type="submit" value="Отправить">')
    $('#comment_text_' + id).html(form)
    $('#redactor_comment_' + id).fadeOut()

  this.edit_cancel = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    $('#comment_text_' + id).html($('#form_edit_comment_' + id + ' textarea').val())
    $('#form_edit_comment_' + id).fadeOut().remove()
    $('#comment_text_' + id).html()
    $('#redactor_comment_' + id).fadeIn()

  this.cancel_reply = (e) ->
    $(this).closest('form').animate
      height: 0, opacity: 0, 500, ->
        $(this).empty()
        $(this).css(opacity: 1, height: '')
    $('#reply_comment_' + $(this).data('id')).fadeIn()

  this.reply_comment = (e) ->
    e.preventDefault()
    id = $(this).data('id')
    project = $(this).data('project')
    path = $(this).data('path')
    form = $('#form_reply_comment_' + id)
    form.append('<br/><textarea class="form-control input-transparent comment-textarea"  name="life_tape_comment[content]" placeholder="Ваш комментарий или вопрос" ></textarea>')
    form.append('<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"></div>')
    form.append('<div class="pull-right">
                                      <div class="btn-group" data-toggle="buttons" id="change_comment_stat">
                                        <label class="btn btn-sm btn-default comment-problem">
                                          <input name="life_tape_comment[discontent_status]" type="hidden" value="0"><input id="life_tape_comment_discontent_status" name="life_tape_comment[discontent_status]" type="checkbox" value="1">
                                          Проблема
                                        </label>
                                        <label class="btn btn-sm btn-default comment-idea">
                                          <input name="life_tape_comment[concept_status]" type="hidden" value="0"><input id="life_tape_comment_concept_status" name="life_tape_comment[concept_status]" type="checkbox" value="1">
                                          Идея
                                        </label>
                                      </div>
                                      <button class="btn btn-danger btn-sm cancel-reply" data-id="' + id + '" type="button">Отмена</button>
                                      <input class="btn btn-sm btn-info send-comment disabled" iname="commit" type="submit" value="Отправить">
                                    </div> <br/>')
    form.hide().fadeIn()
    $('#reply_comment_' + id).fadeOut()

  this.activate_button = ->
    form = $(this).closest('form');
    sendButton = form.find('.send-comment')
    if (this.value? and this.value.length > 1)
      sendButton.removeClass('disabled')
    else
      sendButton.addClass('disabled')

  this.color_for_idea = ->
    $(this).closest('form').find('.comment-idea').toggleClass('btn-warning')

  this.color_for_problem = ->
    $(this).closest('form').find('.comment-problem').toggleClass('btn-danger')

  $('.chat-messages').on('click', 'button.edit-comment', this.edit_comment)
  $('.chat-messages').on('click', 'button.edit-cancel', this.edit_cancel)
  $('.chat-messages').on('click', 'button.reply-comment', this.reply_comment)
  $('.chat-messages').on('click', 'button.cancel-reply', this.cancel_reply)

  $('.form-new-comment').on('keyup', 'textarea.comment-textarea', this.activate_button)
  $('.form-new-comment').on('click', 'label.comment-problem', this.color_for_problem)
  $('.form-new-comment').on('click', 'label.comment-idea', this.color_for_idea)


@resources = ->
  project = $("#option_for_project").attr('data-project')

  this.desc_show = ->
    $(this).closest('.main_res').find('.desc_mean').show()
  this.res_delete = ->
    $(this).closest('.main_res').remove()

  this.add_new_resource_to_concept = ->
    section = $(this).closest('.section-resources').data('section')
    field = section + '_r'
    field2 = section + '_s'
    position = parseInt($('#resources_' + field + ' .main_resources').last().data('position'))
    if not position then position = 1 else position += 1
    resource = $('#resources_' + field)
    resource.append('<div class="main_resources main_res" id="main_' + field + '_' + position + '" data-position="' + position + '">
                        <div class="col-md-8">
                          <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
                          <input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/' + project + '/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor[][name]" placeholder="Введите свой ресурс или выберите из списка" type="text" autocomplete="off">
                          <input name="resor[][type_res]" type="hidden" value="' + field + '">
                        </div>
                        <div class="col-md-4">
                          <div class="pull-right">
                            <button class="btn btn-warning desc_to_res" title="Добавить описание" type="button">
                              <i class="fa fa-edit"></i>
                              Описание
                            </button>
                            <button class="btn btn-success plus_mean" title="Добавить средство" type="button">
                              <i class="fa fa-plus"></i>
                              Средство
                            </button>
                            <button class="btn btn-danger destroy_res" title="Удалить ресурс" type="button">
                              <i class="fa fa-trash-o"></i>
                              Удалить
                            </button>
                          </div>
                        </div>
                        <br><br>
                        <div class="desc_resource" id="desc_' + field + '_' + position + '" data-position="' + position + '" style="display:none;">
                          <textarea class="form-control" id="res" name="resor[][desc]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;"></textarea>
                        </div>
                        <div class="col-md-offset-1 col-md-11 means_to_resource" id="means_' + field2 + '_' + position +'"></div>
                    </div>')
    autocomplete_initialized()
    $('textarea').autosize()

  this.add_new_mean_to_resource = ->
    position = $(this).closest('.main_resources').data('position')
    section = $(this).closest('.section-resources').data('section')
    field = section + '_s'
    mean = $('#means_' + field + '_' + position)
    mean.append('<br/><div class="main_means main_res" id="main_' + field + '_' + position + '" data-position="' + position + '">
                        <div class="col-md-8">
                            <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
                            <input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/' + project + '/autocomplete_concept_post_mean_concept_posts" id="res" min-length="0" name="resor[][means][][name]" placeholder="Введите свой ресурс или выберите из списка" type="text" autocomplete="off">
                            <input name="resor[][means][][type_res]" type="hidden" value="' + field + '">
                        </div>
                        <div class="col-md-4">
                            <div class="pull-right">
                                <button class="btn btn-warning desc_to_res" title="Добавить описание" type="button">
                                  <i class="fa fa-edit"></i>
                                  Описание
                                </button>
                                <button class="btn btn-danger destroy_res" title="Удалить ресурс" type="button">
                                  <i class="fa fa-trash-o"></i>
                                  Удалить
                                </button>
                            </div>
                        </div>
                        <br/><br/>
                        <div class="desc_mean" id="desc_' + field + '_' + position + '" data-position="' + position + '" style="display:none;">
                          <textarea class="form-control" id="res" name="resor[][means][][desc]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;"></textarea>
                          <br>
                        </div>
                      </div>')
    autocomplete_initialized()
    $('textarea').autosize()

  $('#form_for_concept').on('click', 'button.plus_mean', this.add_new_mean_to_resource)
  $('#form_for_concept').on('click', 'button.plus_resource', this.add_new_mean_to_resource)

  $('#form_for_concept').on('click', 'button.desc_to_res', this.desc_show)
  $('#form_for_concept').on('click', 'button.destroy_res', this.res_delete)






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
      if stage = "discontent"
        select_discontent_for_union(project_id,id)
      else if stage = "concept"
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

  $('form.filter_news').on('ifChecked', 'input.iCheck#date_all', this.icheck_date)

  $('form.filter_news').on('ifChecked', 'input.iCheck#by_content', this.icheck_enable)
  $('form.filter_news').on('ifUnchecked', 'input.iCheck#by_content', this.icheck_disable)


@search = ->
  this.search_users = ->
    project_id = $('#search_users_project').attr("data-project")
    val = this.value
    if project_id and val
      $.ajax
        url: "/project/#{project_id}/users/search_users"
        type: "get"
        data:
          search_users_text: val

  $('.search_text').on('change', 'input#search_users_text', this.search_users)


@plan_stage = ->
  $('.plan_tabs').on('click', 'ul#PlanTabs li#second a', render_table('edit'))
  $('.plan_tabs').on('click', 'ul#PlanTabs li#third a', render_concept_side())
  $('.plan_tabs').on('click', 'ul#PlanTabsShow li#second a', render_table('show'))
  $('.plan_tabs').on('click', 'ul#PlanTabsShow li#third a', render_concept_side())


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
    setup: (ed) ->
      ed.on "init", (ed) ->
        tinyMCE.get(ed.target.id).show()
    plugins:
      ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
       "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
       "save table contextmenu directionality emoticons template paste textcolor"]
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons"


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
  sel = $('#selectize_discontent :selected')
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
  sel = $('#selectize_concept :selected')
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
@activate_wizard= ->
  $("#wizard").bootstrapWizard onTabShow: (tab, navigation, index) ->
    $total = navigation.find("li").length
    $current = index + 1
    $percent = ($current / $total) * 100
    $wizard = $("#wizard")
    $wizard.find(".progress-bar").css width: $percent + "%"
    #$('#option_for_wizard_tab').attr("data-tab","#{$current}")
    go_string = 'Перейти к описанию'
    names_blocks = ['Идеи','Функционирования','Нежелательных побочных эффектов','Контроля','Целесообразности','Решаемых несовершенств']
    if $current >= $total
      $wizard.find(".pager .next").hide()
      $('#form_save').show()
    else
      if $current == 1
        $wizard.find(".pager .previous").hide()
        $wizard.find(".pager .next .btn").html("#{go_string} #{names_blocks[$current - 1]} <i class=\"fa fa-caret-right\"></i>")
        $('#form_save').hide()
      else if $current in [2,3,4,5,6]
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html("#{go_string} #{names_blocks[$current - 1]} <i class=\"fa fa-caret-right\"></i>")
        $('#form_save').show()
      else
        $wizard.find(".pager .previous").show()
        $wizard.find(".pager .next .btn").html('Далее <i class="fa fa-caret-right"></i>')
        $('#form_save').show()
      $wizard.find(".pager .next").show()
    scrollTo(0,0)

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

# @todo datepicker for plan posts

@activate_datepicker = ->
  $date_begin = $("#date_begin")
  $date_end = $("#date_end")

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