#open magnific popup open
@magnificPopupOpenWithClose = (el, data={} )->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline',
    fixedContentPos: false,
    fixedBgPos:true
    callbacks:
      close: -> data.callbackOnClose()  if  data.callbackOnClose?

@magnificPopupOpen = (el, data={})->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline'
    closeOnContentClick: false
    closeOnBgClick: false
    closeBtnInside: false
    showCloseBtn: false
    enableEscapeKey: false
    callbacks:
      close: -> data.callbackOnClose()  if  data.callbackOnClose?

@modalInit= (el, data={}) ->
  data.withClose?=true
  $(el).modal('show')
#  if data.withClose
#    magnificPopupOpenWithClose(el, data)
#  else
#    popup = magnificPopupOpen(el, data)
#    $('.close_magnific').click ->
#      @popupClose()

@popupClose = ->
  magnificPopup = $.magnificPopup.instance
  magnificPopup.close()



@tooltipInit = (el) ->
  $(el).tooltip()
@tooltipToggle = (el) ->
  $(el).tooltip('toggle')


@progressDiagramInit = (el) ->
  $(el).knob
    width: 36
    height: 36
    readOnly: true

#animate knob progress bar from data-end
@progressDiagramChange = (el)->
  $(el).each ->
    cur =$(this)
    newValue = cur.data('end')
    $({animatedVal: cur.val()}).animate {animatedVal: newValue},
      duration: 3000,
      easing: "swing",
      step: ->
        cur.val(Math.ceil(this.animatedVal)).trigger("change")

@carousellInit = (el, interval=false) ->
  $(el).carousel
    interval: interval,
    pause: "hover"
#цвет модального окна базы знаний
@color_modal_knowbase = (el) ->
  $(el).on 'slid.bs.carousel', ->
    bgcolor = $('.myCarousel-target.active').attr('data-color')
    $(el+' .header').css({background: bgcolor})
    $('.myCarousel-control').css({color: bgcolor})


@projectTaskManagerInit = (el, dataSource ) ->
  if $('#gantEditorTemplates').length > 0
    @ge = new GanttMaster()
    @ge.init($(el))
    ret = JSON.parse($(dataSource).val())
    unless ret == null
      offset = (new Date).getTime() - ret.tasks[0].start
      task.start += offset  for task in ret.tasks
      @ge.loadProject(ret)









