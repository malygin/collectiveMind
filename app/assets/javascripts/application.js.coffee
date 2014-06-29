#= require jquery
#= require jquery_ujs
#= require_tree
#= require jquery.ui.all
#= require twitter/bootstrap
#= require autocomplete-rails
#= require bootstrap-wysihtml5/b3
#= require bootstrap-wysihtml5/locales/ru-RU
#= require selectize
#= require liFixar/jquery.liFixar
#= require slimscroll/jquery.slimscroll
#= require wizard/wizard
#= require wizard/jquery.bootstrap.wizard
#= require wizard/underscore-min
#= require wizard/bootstrap-datepicker
#= require wizard/jquery.maskedinput
#= require wizard/select2
#= require bootstrap3-editable/bootstrap-editable
#= require wizard/jquery.pjax
#= require jquery.autosize

$('#modal_help').modal
  keyboard: false
  backdrop: 'static'

$('#modal_help').on 'hidden.bs.modal', ->
  $('#help_question').submit()
  $('#modal_help').remove()

@get_life_tape_form = ->
  $('#new_life_tape').css 'display','block'
  $("#add_record").fadeOut("slow").hide()
  $("#new_life_tape").animate {height: 100}, "normal"
  $("#button_block").stop().show().animate {
    left:$('#new_life_tape').width() - 370
    opacity:1.000 }

@reset_life_tape_form = ->
  $("#button_block").animate({left:0, opacity:0.000 }, 'normal', ->
    $("#button_block").css 'display', 'none')
  $("#new_life_tape").animate {
    height: 0
  }, "normal",  ->
    $('#new_life_tape').css('display','none')
  $("#add_record").fadeIn('slow')

@show_filter_aspects_button = ->
  $('#aspects_list').submit()
#  $('#filter-aspect').stop().show().animate {
#    left: 15
#    opacity: 1}

@reset_filter_aspects = ->
  $('input[type=checkbox]').prop('checked','')
  show_filter_aspects_button()

@activate_button = (el)->
  if el.value? and el.value!=''
    $('#send_post').removeClass('disabled')
  else
    $('#send_post').addClass('disabled')
  $('#new_discontent_hidden').remove()

@activate_modal_send = (el)->
  if $( ".radio input:checked" ).length == 1
    $('#send').removeClass('disabled')

@remove_block = (el)->
  $('#'+el).remove()

@disontent_form_submit= ->
#   $('#send_post').html('Ищем совпадения ...')
#  $('#send_post').toggleClass('disabled')

@disable_send_button= ->
  $('#send_post').toggleClass('disabled')

$('.score_class').on 'click', ->
  $('.score_class').css('text-decoration','none').css('background-color','transparent')
  $(this).css('text-decoration','underline').css('background-color','#ddeaf4')

@load_discontent_for_cond= (el)->
  $.ajax({
    type: "POST",
    url: "/project/1/plan/posts/get_cond",
    data: { pa: $('#select_'+el).val() },

  })

@activate_htmleditor= ->
  @editor = $(".wysihtml5").each (i, elem) ->
    $(elem).wysihtml5
      "font-styles": true
      emphasis: true
      lists: true
      html: true
      link: true
      image: true
      color: true
#      events:
#        load: ->
#          $(".wysihtml5-sandbox").contents().find("body").on "change", ->
#            activate_button_editor()

$ ->
  $("#sortable").sortable()
  $("#sortable").disableSelection()
  $('#theall a:first').tab('show')


#  $('#accordion').on 'shown.bs.collapse', ->
#    m = $(this);
#    console.log(m)
#    alert(m)

#  $("input#discontent_post_whend ").autocomplete(
#    minLength: 0
#  ).focus ->
#    $(this).autocomplete "search", ""
#    return
#
#  $("input#discontent_post_whered ").autocomplete(
#    minLength: 0
#  ).focus ->
#    $(this).autocomplete "search", ""
#    return
  $("input.autocomplete ").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return


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



@select_discontent_for_union= (project,id)->
  sel = $('#selectize_tag :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/discontent/posts/#{id}/add_union"
      type: "put"
      data:
        post_id: sel.val()

@select_discontent_for_union_add_list= (project,id)->
  sel = $('#selectize_tag_for_union :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/discontent/posts/#{id}/add_union"
      type: "put"
      data:
        post_id: sel.val()
        add_list: true

$(window).load ->
  $('textarea').autosize()
  $select = $("#selectize_tag").selectize
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


  $select_for_union = $("#selectize_tag_for_union").selectize
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
      select_discontent_for_union_add_list(project_id,id)
      selectize = $select_for_union[0].selectize
      selectize.removeOption(item)
      selectize.refreshOptions()
      selectize.close()
    render:
      item: (item, escape) ->
        short_item = item.show_content.split('<br/>')[0].replace('<b> что: </b>', '')
        return '<div>'+short_item+'</div>'
      option: (item, escape) ->
        return '<div>'+item.show_content+'</div>'

@select_discontent_for_concept= (project,id)->
  sel = $('#selectize_concept :selected')
  if sel.val() != ''
    $.ajax
      url: "/project/#{project}/concept/posts/add_dispost"
      type: "post"
      data:
        dispost_id: sel.val()
        remove_able: 1

$(window).load ->
  $('.liFixar').liFixar()
  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
    autoclose: true
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"
    return

  $('.userscore').editable()
#  $('.userscore').editable
#    type: 'text'
#    pk: 1
#    placement: 'top'
#    title: 'enter score'
#    url: '/post'
#    source: '/list'



#  $(".chat-messages").slimScroll
#    start: 'bottom'
#    size: '5px'
#    alwaysVisible: true
#    railVisible: true
#    disableFadeOut: true
#
#  $(".chat-messages").scrollTop(10000);

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
      select_discontent_for_concept(project_id,id)
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

  $("input.autocomplete ").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

#@activate_button_editor = ->
#  input = $('#title-textfield')
#  editor = $('.wysihtml5').data('wysihtml5').editor
#  html = editor.getValue()
#  if input? and input.val()!=''
#    $('#send_post').removeClass('disabled')
#  else
#    $('#send_post').addClass('disabled')

$('#select_for_aspects').on 'change', ->
  val=this.value
  text=$(this).find('option:selected').text()
  $(this).find('option:selected').remove()
  func = "'#{val}','#{text}'"
  $('#add_post_aspects').append('<div id="aspect_'+val+'" style="display:none;height:0;"><input type="hidden" name="discontent_post_aspects[]" value="'+val+'"/><span class="glyphicon glyphicon-remove text-danger pull-left" onclick="remove_discontent_aspect('+func+');" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span id="'+val+'" class="span_aspect label label-t">'+text+'</span></br></div>')
  $('#aspect_'+val).css('display','block').animate({height: 20, opacity:1}, 500).effect("highlight", {color: '#f5cecd'}, 500)
  activate_discontent_aspect()

@reset_post_note_form= (post,type)->
  $('#note_for_post_'+post+'_'+type).remove();
  $('#content_dispost_'+post+'_'+type).removeClass('disabled');

@remove_discontent_aspect= (val,text)->
  $('#aspect_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_for_aspects').append(new Option(text,val))
  activate_discontent_aspect()

@activate_discontent_aspect= ->
  setTimeout (->
    if $("#add_post_aspects div").length
      $('#send_post').removeClass('disabled')
    else
      $('#send_post').addClass('disabled')
  ), 1500

@remove_discontent_post= (val)->
  $('#post_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())

@add_new_resource_to_concept= ->
  $('#resources').append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/1/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res_" name="res[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  $("input.autocomplete ").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

@plan_select_aspect= (el)->
  optsel = $("#option_for_select_concept")
  project_id = parseInt(optsel.attr('project'))
  aspect_id = $(el).val()
  if aspect_id is "0"
    $("#select_concept").attr "disabled", true
    return (false)
  $("#select_concept").attr "disabled", true
  $("#select_concept").empty()
  if aspect_id != ''
    $.ajax
      url: "/project/#{project_id}/plan/posts/get_concepts"
      type: "post"
      data:
        aspect_id: aspect_id

#@plan_select_concept= (el)->
#  concept_id = $(el).val()
#  if concept_id is "0"
#    return (false)
#  title=$(el).find('option:selected').text()
#  $(el).find('option:selected').remove()
#  func = "'#{concept_id}','#{title}'"
#  $('#aspect_concepts').append('<div id="concept_aspect_'+concept_id+'" style="display:none;height:0;"><input type="hidden" name="plan_aspect_concepts[]" value="'+concept_id+'"/><span class="glyphicon glyphicon-remove text-danger pull-left" onclick="remove_aspect_concept('+func+');" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span id="'+concept_id+'" class="span_aspect label label-t">'+title+'</span></br></div>')
#  $('#concept_aspect_'+concept_id).css('display','block').animate({height: 20, opacity:1}, 500).effect("highlight", {color: '#f5cecd'}, 500)

@remove_aspect_concept= (val,text)->
  $('#concept_aspect_'+val).animate({height: 0, opacity: 0.000}, 1000, ->
    $(this).remove())
  $('#select_concept').append('<option id="option_'+val+'" value="'+val+'">'+text+'</option>')

@empty_modal_plan= ->
  $("#select_aspect option:first").prop "selected", "selected"
  $("#select_concept").empty()
  $("#select_concept").attr "disabled", true
  $("#aspect_concepts").empty()

#@add_new_resource_to_plan= (concept)->
#  $('#resources_'+concept).append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/1/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor['+concept+'][]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res_" name="res['+concept+'][]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
#  $("input.autocomplete ").autocomplete(
#    minLength: 0
#  ).click ->
#    $(this).autocomplete "search", ""
#    return

@autocomplete_initialized= ->
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

@remove_plan_concept= (el,cp)->
  $(el).parent().parent().remove()
  $("#asp_"+cp).remove()

@activate_wizard= ->
  $('.chzn-select').select2();
  $("#destination").mask("99999");
  $("#credit").mask("9999-9999-9999-9999");
  $("#expiration-date").datepicker();
  $("#wizard").bootstrapWizard onTabShow: (tab, navigation, index) ->
    $total = navigation.find("li").length
    $current = index + 1
    $percent = ($current / $total) * 100
    $wizard = $("#wizard")
    $wizard.find(".progress-bar").css width: $percent + "%"
    if $current >= $total
      $wizard.find(".pager .next").hide()
      $wizard.find(".pager .finish").show()
      $wizard.find(".pager .finish").removeClass "disabled"
    else
      $wizard.find(".pager .next").show()
      $wizard.find(".pager .finish").hide()
    return


@discussion_select_aspect= (el)->
  optsel = $("#option_for_select_discontent")
  project_id = parseInt(optsel.attr('project'))
  aspect_id = $(el).val()
  if aspect_id != ''
    $.ajax
      url: "/project/#{project_id}/discontent/posts/fast_discussion_discontents"
      type: "get"
      data:
        aspect_id: aspect_id

@user_check_field= (el,check_field)->
  optsel = $("#option_for_select_discontent")
  project_id = parseInt(optsel.attr('project'))
  if ( $(el).is( ":checked" ) )
    status = true
  else
    status = false
  if check_field != ''
    $.ajax
      url: "/project/#{project_id}/discontent/posts/check_field"
      type: "get"
      data:
        check_field: check_field
        status: status



#@activate_discussion_selectize= ->
#  $select = $("#select_for_discussion_discontents").selectize
#    labelField: "show_content"
#    valueField: "id"
#    sortField: "show_content"
#    searchField: "show_content"
#    create: false
##    hideSelected: true
#    onChange: (item) ->
#      optsel = $("#option_for_select_discontent")
#      project_id = parseInt(optsel.attr('project'))
##      id = parseInt(optsel.attr('post'))
#      select_discontent_for_discussion_concepts(project_id)
#      selectize = $select[0].selectize
##      selectize.removeOption(item)
##      selectize.refreshOptions()
##      selectize.close()
#    render:
#      item: (item, escape) ->
#        short_item = item.show_content.split('<br/>')[0].replace('<b> что: </b>', '')
#        return '<div>'+short_item+'</div>'
#      option: (item, escape) ->
#        return '<div>'+item.show_content+'</div>'

#@select_discontent_for_discussion_concepts= (project)->
#  sel = $('#select_for_discussion_discontents :selected')
#  if sel.val() != ''
#    $.ajax
#      url: "/project/#{project}/concept/posts/fast_discussion_concepts"
#      type: "get"
#      data:
#        sel_dis_id: sel.val()


@discussion_select_discontent= (el)->
  optsel = $("#option_for_select_discontent")
  project_id = parseInt(optsel.attr('project'))
  sel_dis_id = $(el).val()
  if sel_dis_id != ''
    $.ajax
      url: "/project/#{project_id}/concept/posts/fast_discussion_concepts"
      type: "get"
      data:
        sel_dis_id: sel_dis_id

@discussion_select_discontent_add_concept= (el)->
  optsel = $("#option_for_select_discontent")
  project_id = parseInt(optsel.attr('project'))
  sel_dis_id = $(el).val()
  if sel_dis_id != ''
    $.ajax
      url: "/project/#{project_id}/concept/posts/fast_discussion_concepts"
      type: "get"
      data:
        sel_dis_id: sel_dis_id
        add_concept: 1

@activate_datepicker= ->
  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd'
  ).on "changeDate", (e) ->
    $(this).datepicker "hide"

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

@add_new_resource_to_plan= (field)->
  $('#resources_'+field).append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod" data-autocomplete="/project/1/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_'+field+'[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res'+field+'[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

@add_new_action_resource_to_plan= ->
  $('#action_resources').append('<div class="panel panel-default"><div class="panel-body"><span class="glyphicon glyphicon-remove text-danger pull-right" onclick="$(this).parent().parent().remove();" style="cursor:pointer;text-decoration:none;font-size:15px;"></span><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input class="form-control autocomplete ui-autocomplete-input" data-append-to="#mod2" data-autocomplete="/project/1/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor_action[]" placeholder="Введите свой ресурс или выберите из списка" size="30" type="text" autocomplete="off"><br><textarea class="form-control" id="res" name="res_action[]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 54px;"></textarea></div></div>')
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return


@render_table= ->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_table"
      type: "put"

@render_concept_side= ->
  optsel = $("#option_for_render_tab")
  project_id = parseInt(optsel.attr('project'))
  post_id = parseInt(optsel.attr('post'))
  if project_id and post_id
    $.ajax
      url: "/project/#{project_id}/plan/posts/#{post_id}/render_concept_side"
      type: "put"

#$(window).load ->
#  $("#first").on "click", ->
#    $('#send_post_concept').submit()
#  $("#second").on "click", ->
#    render_table()
#    $('#send_post_concept').submit()
#  $("#third").on "click", ->
#    render_concept_side()

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

#  last_id = $('ul.panel-collapse li.active').attr('id')
#  -unless typeof last_id is 'undefined'

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


@reset_child_comment_form= (comment)->
  $('#child_comments_form_'+comment).empty()

@render_concept_collapse= (post,concept)->
  con_id = $("#collapse_plus_concept_"+post+"_"+concept).attr('id')
  if typeof con_id is 'undefined'
    return true
  else
    return false
