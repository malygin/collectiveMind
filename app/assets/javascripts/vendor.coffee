popoverTemplate = [
  '<div class="popover help_popover_content cl_btn_container">'
  '<div class="arrow"></div>'
  '<a data-remote="true" rel="nofollow" id="close_help_popover" data-method="put" href="/project/' + $('.help_popover').data('project') + '/' + $('.help_popover').data('stage') + '/posts/check_field?check_field=' + $('.help_popover').data('status') + '&status=true">'
  '<i class="fa fa-times cl_btn font_white" onclick="$(\'.help_popover\').popover(\'hide\');"></i></a>'
  '<div class="popover-content font_white">'
  '</div>'
  '</div>'
].join('')

$('.help_popover').popover
  selector: '[rel=popover]'
  trigger: 'manual'
  placement: 'bottom'
  container: 'body'
  content: $('.help_popover').data('text')
  template: popoverTemplate
  html: true

$('.help_popover').click ->
  $(this).popover 'toggle'