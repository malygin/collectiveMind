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

#= require news
#= require notifications
#= require utils

# @todo load initialization

$ ->
  comments_feed()

  notificate_my_journals()
  sidebar_for_small_screen()
  activate_htmleditor()
  autocomplete_initialized()
  estimate_color_select_init()




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






  $('.tooltips').tooltip()




  $().UItoTop easingType: "easeOutQuart"

  $("#sortable").sortable()
  $("#sortable").disableSelection()


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
