@save_plan = () ->
  console.log(ge.saveProject())
#animate knob progress bar from data-end
@animateKnobChange = (el)->
  $(el).each ->
    cur =$(this);
    newValue = cur.data('end');
    $({animatedVal: cur.val()}).animate {animatedVal: newValue},
      duration: 3000,
      easing: "swing",
      step: ->
        cur.val(Math.ceil(this.animatedVal)).trigger("change")

#open magnific popup open
@magnificPopupOpen = (el)->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline'

#open magnific popup close
@magnificPopupClose = (el)->
  $.magnificPopup.close
    items: {src: el},
    type: 'inline'

# get new question in 1st stage
@getNextQuestion = (question, aspect)->
  # if we have more questions in aspect
  if($("#question_"+question).next().length)
      $("#questionsCarousel_"+aspect).carousel('next')
      $("#question_count_"+aspect).html(parseInt($("#question_count_"+aspect).html())+1)
  else
    # else we try to active next aspect
    $('#aspect_block_'+aspect).html('<div class="divider20"></div><h4 class="block-with-left-icon pull-left"><i class="left-icon fa fa-2x fa-comments"></i>Вы ответили на все вопросы по данному аспекту.</h4><span class="pull-right question_count"></span><div class="carousel-inner"></div>')
    $('#li_aspect_'+aspect).addClass('complete')
    if($(".li_aspect:not(.complete)").length)
#      $('#li_aspect_'+aspect).removeClass('active')
#      $('#li_aspect_'+aspect+' .slider-item').removeClass('active');
#      $('#li_aspect_'+aspect).parent().find('.li_aspect:not(.complete):first').find('.slider-item').addClass('active');
      $('.li_aspect').removeClass('active')
      $('.slider-item').removeClass('active')
      $('#li_aspect_'+aspect).parent().find('.li_aspect:not(.complete):first').find('a').tab('show');
    else
      # else we have not more aspects, we just show greetings
      if($("#popup-greetings-text").length)
        magnificPopupOpen('#popup-greetings-text')
      else
        setTimeout (->
          window.location.reload(true)
          return
        ), 1000

@reload_isotope = ->
  $('#tab_aspect_posts').isotope('reloadItems').isotope()

@check_discontents= (el)->
  arr = []
  $(el).find('input:checked').closest('.checkox_item').each (index, element) ->
    if $(element).data('discontent') == '*'
      arr = $(element).data('discontent')
      return false
    else
      arr.push(if $(element).data('discontent').match(/(\d+)/) then $(element).data('discontent').match(/(\d+)/)[1] else $(element).data('discontent'))
  return arr

# get project id from url like /project/11/discontent/posts
@getProjectIdByUrl = ()->
#  url = window.location.href.match(/\d+/g)
#  return url[url.length-1]
#  универсализация
  url = window.location.href.match(/project\/(\d+)/)
  if url
    return url[1]

@parse_my_journal_links = ()->
  #  if window.location.href.indexOf("discontent/posts") > -1
  #  $('#comment_content_' + link.match(/comment_(\d+)/)[1]).effect("highlight", 3000);
  link = document.location.toString();
  if link.match(/project\/(\d+)/)
    project_id = link.match(/project\/(\d+)/)[1]
  if link.match(/jr_post=(\d+)/)
    post_id = link.match(/jr_post=(\d+)/)[1]
  if link.match(/jr_comment=(\d+)/)
    comment_id = link.match(/jr_comment=(\d+)/)[1]
  if link.match(/project\/(\d+)\/(\w+)\/posts/)
    stage = link.match(/project\/(\d+)\/(\w+)\/posts/)[2]
    if stage == 'collect_info'
      stage = 'aspect'

  if project_id and post_id and stage
    $.ajax
      url: "/project/#{project_id}/#{stage}/posts/#{post_id}"
      type: "get"
      dataType: "script"


# чтение отдельной новости эксперта в попапе
@expert_news = ->
  this.expert_news_read = ->
    project_id = $(this).data('project')
    news_id = $(this).data('id')
    # проверяем и добавляем класс, чтобы исключить дублирование лога
    read = $(this).hasClass('read')
    if project_id and news_id and !read
      $(this).addClass('read')
      # убираем статус
      $(this).find('.status_news').html('')
      unless($(".expert_news_drop .dd_xprt_notice a:not(.read)").length)
        $('.drop_opener i').css 'color', '#9e9e9e'
      $.ajax
        url: "/project/#{project_id}/news/#{news_id}/read"
        type: "get"
        dataType: "script"

  $('.expert_news_drop').on('click', '.dd_xprt_notice a', this.expert_news_read)

# голосование за пост
@vote_buttons = ->
  this.vote_post = ->
    project_id = $(this).data('project')
    post_id = $(this).data('id')
    stage = $(this).data('stage')
    status = $(this).data('status')
    if project_id and post_id and stage and status
      $.ajax
        url: "/project/#{project_id}/#{stage}/posts/#{post_id}/vote"
        type: "put"
        dataType: "script"
        data:
          status: status

  this.vote_plan = ->
    project_id = $(this).data('project')
    post_id = $(this).data('id')
    type_vote = $(this).data('type-vote')
    status = $(this).data('status')
    if project_id and post_id and type_vote and status
      $.ajax
        url: "/project/#{project_id}/plan/posts/#{post_id}/vote"
        type: "put"
        dataType: "script"
        data:
          type_vote: type_vote
          status: status

  $('.vote_controls').on('click', '.vote_button', this.vote_post)
  $('.rate_buttons').on('click', '.btn_plan_vote', this.vote_plan)


#----------
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


$('#tab_posts li#new a').on "click", (e) ->
  project_id = $(this).data('project')
  $('#spinner_tab_unions').show()
  if project_id
    $.ajax
      url: "/project/#{project_id}/discontent/posts/unions"
      type: "get"


@plan_stage = ->
  this.select_plans = ->
    project_id = $(this).data('project')
    val = this.value
    if project_id and val
      $.ajax
        url: "/project/#{project_id}/estimate/posts/new"
        type: "get"
        dataType: "script"
        data:
          plan_id: val

  $('#tab-for_content').on('change', '#select_plans', this.select_plans)

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
  $('#modal_stage').on('keyup', 'input.name-stage', this.activate_button)



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

# @todo work with comment on collect_info posts
@select_for_aspects_comments = (el, project, post)->
  project_id = project
  comment_id = post
  aspect_id = $(el).val()
  if aspect_id != '' and comment_id != ''
    $.ajax
      url: "/project/#{project_id}/collect_info/posts/transfer_comment"
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
    $('#add_post_aspects').append('<div id="aspect_' + val + '" style="display:none;height:0;"><input type="hidden" name="discontent_post_aspects[]" value="' + val + '"/><span class="fa fa-remove text-danger pull-left" onclick="remove_core_aspect(' + func + ');" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span id="' + val + '" class="span_aspect label label-xs label-info">' + text + '</span></br></div>')
    $('#aspect_' + val).css('display', 'block').animate({height: 20, opacity: 1}, 500).effect("highlight",
      {color: '#f5cecd'}, 500)

@remove_core_aspect = (val, text)->
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
      url: "/project/#{project_id}/plan/posts/#{post_id}/aspects/add_form_for_concept"
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
        url: "/project/#{project_id}/plan/posts/#{post_id}/aspects/get_concept"
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

@start_autocomplete = ->
  $('.autocomplete').each ->
    console.log($(this).attr('data-url'))
    $(this).autocomplete(source: $(this).attr('data-url'))
    return

@start_vote = ->
  if $('div[id^=popup-vote]').length > 0
    $.magnificPopup.open({
      items: {
        src: $('div[id^=popup-vote]')
      },
      type: 'inline'
    });
  return

@add_comment_by_enter = ->
  if $('input[id^=_comment_content]').length > 0
    $('input[id^=_comment_content]').keypress = (e)->
      if (e.which == 10 || e.which == 13)
        this.parent.submit()
      return

@start_play = ->
  $('#player-container').tubeplayer
    width: $('#play_video').width()
    height: 450
    allowFullScreen: 'true'
    initialVideo: 'YA1S941EdAY'
    preferredQuality: 'default'
    showControls: 0
    modestbranding: false
    onPlayerEnded: ->
      $('#player-container').tubeplayer 'destroy'
      $('#play_video').remove()
      $('#message-before-movie').remove()
      delay = 4000
      $('#message-after-movie').fadeIn('slow').delay(delay - 10).fadeOut('slow')
      $('#movie_watched').click()
      $('#concept-main').delay(delay).fadeIn('slow')
      $('#concept-comments-main').delay(delay).fadeIn('slow')
      return
  $('#play_video').on 'click', ->
    if ($(this).attr('data-stage') == 'play')
      $('#player-container').tubeplayer 'play'
      $(this).text('Поставить на паузу')
      $(this).attr('data-stage', 'pause')
    else
      $('#player-container').tubeplayer 'pause'
      $(this).text('Продолжить просмотр')
      $(this).attr('data-stage', 'play')
    return

#show comments panel on post hover
@show_comments_hover = ->
  $('.ch_action').unbind().hover ->
    ch_id = $(this).attr('data-for')
    $('.comments_icon[data-for= "' + ch_id + '"]').toggleClass 'active'
    $('#' + ch_id).toggleClass 'active'
    return

# perfect scrollbar
@activate_perfect_scrollbar = ->
  $('.ps_cont.half_wheel_speed').perfectScrollbar wheelSpeed: 0.3
  $('.ps_cont').perfectScrollbar()

#  post colored stripes
#  показ цветных полосок -> упростить
@post_colored_stripes = ->
  count_themes_width = (cont) ->
    width = 0
    $('#' + cont + ' .tag-stripes').each ->
      width = width + $(this).outerWidth()
      return
    width + 100

  $('.post-theme').each ->
    curId = $(this).attr('id')
    $(this).width count_themes_width(curId)
    return
  $('.post-theme').hover ->
    curId = $(this).attr('id')
    $('#' + curId + ' .tag-stripes').hover ->
      $('#' + curId + ' .tag-stripes').removeClass 'active'
      $(this).addClass 'active'
      return
    return
  $('.post-theme').mouseover ->
    $(this).addClass 'shown'
    $(this).closest('.themes_cont').addClass 'themesShown'
    return
  $('.post-theme').mouseleave ->
    $(this).removeClass 'shown'
    $(this).closest('.themes_cont').removeClass 'themesShown'
    return
  $('.tag-stripes').mouseover ->
    $(this).closest('.post-theme').width count_themes_width($(this).closest('.post-theme').attr('id'))
    return

# сворачивание комментов и скролл
@comments_expandable_column = ->
  $('.expand_button').click ->
    col = $(this).attr('data-col')
    $('.popup_expandable_col').toggleClass('col-md-' + col).toggleClass('col-md-12').toggleClass 'exp'
    $('.popup_expandable_col.ps_cont').perfectScrollbar 'update'
    return
  $('.comment_col .collapse').on 'shown.bs.collapse', ->
    $('.popup_expandable_col.ps_cont').perfectScrollbar 'update'
    return
  $('.comment_col .collapse').on 'hidden.bs.collapse', ->
    $('.popup_expandable_col.ps_cont').perfectScrollbar 'update'
    return
  $('.answers_collapse').click ->
    $(this).toggleClass 'opened'
    return
  $('.com_answers').on 'shown.bs.collapse', ->
    $('.modal_content.ps_cont').perfectScrollbar 'update'
    return
  $('.com_answers').on 'hidden.bs.collapse', ->
    $('.modal_content.ps_cont').perfectScrollbar 'update'
    return

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



# временно!!!
# цвета для несовершенств
@colors_discontents = ->
  color_item = (object, action, color) ->
    object.css action, '#' + color
    return

  $('.color_me').each ->
    me = $(this)
    type = me.attr('data-me-type')
    if type == 'imperf'
      color = $colors_imperf_codes[me.attr('data-me-color')]
    action = me.attr('data-me-action')
    if action and color
      color_item me, action, color
    return

$colors_imperf_codes = [
  'd3a5c9'
  'a7b3dd'
  '87a9f3'
  '8d9caf'
  '85dbf2'
  '91c5d0'
  '8ad2be'
  'a6d1a6'
  'd7d49d'
  'f3e47d'
  'f9bf91'
  'eca3b7'
  'e67092'
  '6ea3f1'
  'a5bdad'
  '81dad6'
  '96afb6'
  'be85ca'
  'fbcd82'
  '79889b'
  'd3e18c'
  'eea266'
  'b7e3f0'
  '7dc7f6'
  'f7947f'
  'e2de95'
  '8fbce5'
  '7181d9'
  'b9daa3'
  'dc7674'
  '77b7f5'
  'ff7b67'
  'e8aa79'
  'd0596c'
  'ac87bd'
  'e89ec3'
  'feb497'
  'b67c94'
  '8790d3'
  '89b5f4'
  'b46a6b'
  'ff8f5f'
  '88a0ce'
  'cd97c9'
  '7391da'
  'fdaa68'
  'b45f58'
  '8fb5e6'
  'fea1cd'
  '978ac2'
]

$('.with_plus').click ->
  $(this).find('i.collapse_plus').toggleClass('fa-plus').toggleClass('fa-minus')
  return
