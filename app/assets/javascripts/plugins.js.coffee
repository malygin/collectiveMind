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

# @todo autocomplete
@autocomplete_initialized = ->
  $("input.autocomplete").autocomplete(
    minLength: 0
  ).click ->
    $(this).autocomplete "search", ""
    return

# @todo htmleditor
@activate_htmleditor = ->
  tinyMCE.init
    selector: "textarea.tinymce"
    language: "ru"
    plugins:
      ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
       "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
       "save table contextmenu directionality emoticons template paste textcolor"]
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons"

@сommand_htmleditor = (сommand, id) ->
  if сommand == 'remove'
    tinymce.EditorManager.execCommand('mceRemoveEditor', false, id);
  else if сommand == 'add'
    tinymce.EditorManager.execCommand('mceAddEditor', false, id);