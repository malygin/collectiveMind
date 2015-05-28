$('.cabinet-aspect-form-checkb input').click ->
  me = $(this)
  attrname = me.attr('name')
  $('input[name=\'' + attrname + '\']').removeClass 'active-radio'
  me.addClass 'active-radio'
  return
$('.cabinet-tabs-subblock-2ndlev-li a').click ->
  if !$(this).hasClass('active-2ndlev-li')
    $('.cabinet-tabs-subblock-2ndlev-li a').each ->
      $(this).removeClass 'active-2ndlev-li'
      return
    $(this).addClass 'active-2ndlev-li'
  return
$('.cabinet-tabs .cabinet-tabs-subblock>li>a').click ->
  $('.cabinet-tabs-subblock-2ndlev-li a').each ->
    $(this).removeClass 'active-2ndlev-li'
    return
  return
