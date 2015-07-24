#open magnific popup open
@magnificPopupOpenWithClose = (el)->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline',
    fixedContentPos: false,
    fixedBgPos:true

@magnificPopupOpen = (el)->
  $.magnificPopup.open
    items: {src: el},
    type: 'inline'
    closeOnContentClick: false
    closeOnBgClick: false
    closeBtnInside: false
    showCloseBtn: false
    enableEscapeKey: false

@popupInit= (el, withClose=true) ->
  console.log el, withClose
  if withClose
    magnificPopupOpenWithClose(el)
  else
    popup = magnificPopupOpen(el)
    $('.close_magnific').click ->
      magnificPopup = $.magnificPopup.instance
      magnificPopup.close()

#@tooltipInit= (el) ->
#@progressDiagramInit
#@carousellInit








