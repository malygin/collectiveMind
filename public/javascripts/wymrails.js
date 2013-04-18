$(function() {
    $('.wymeditor').wymeditor({
      skin: 'compact',
      logoHtml: '',
      toolsItems: [
          {'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},
          {'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},
          {'name': 'Indent', 'title': 'Indent', 'css': 'wym_tools_indent'},
          {'name': 'Outdent', 'title': 'Outdent', 'css': 'wym_tools_outdent'},
          {'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},
          {'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'}
      ]
      })
	$('input[type=submit]').addClass('wymupdate');
});
