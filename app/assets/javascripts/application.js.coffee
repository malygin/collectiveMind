#= require jquery
#= require jquery_ujs

#$(document).ready ->
#  window.wiselinks = new Wiselinks()
$(document).ready ->
    $(".voteBar")
      .bind "ajax:success", (event, resp) ->
        $(this).replaceWith "Вы проголосовали, спасибо!"
        i = $('span#count_vote').text() - 1
        console.log( $('span#count_vote').text(), i)
        if (i < 1)
          $('a.voteCounter').each (i, element)  =>
            $(element).replaceWith ""    
    $(".adminVoteBar")
      .bind "ajax:success", (event, resp) ->
        $(this).replaceWith "Выбрано!"
     
      .bind "ajax:error", (event, resp) ->
        $(this).replaceWith ""+resp 
    $(".scoreBar")
      .bind "ajax:success", (event, resp) ->
        $(this).replaceWith "Вы выдали баллы, спасибо!"    
      .bind "ajax:error", (event, resp) ->
        $(this).replaceWith ""+resp
    $(".counter")
      .bind "ajax:success", (event, resp) ->
        console.log(resp)
        $(this).replaceWith ""+resp
    $('.task_supply > ol > li > ul ').before('<br/><span class="task_supply_resource">Ресурсы:</span>')
    $('.task_supply > ol > li > ul > li > ul ').before('<br/><span class="task_supply_resource">Средства создания:</span>')
   
root = exports ? this

root.addTask =  (x) -> 

  $('.links').before('<tr class="ts">  <td><textarea class="wymeditor" id="task_supply_'+x+'" name="task_supply['+x+']"></textarea></td>    <td><a href="#" onclick=" $(this).parent().parent().remove(); return false;"><img alt="Close" src="/assets/close.png"></a></td></tr>')
  $('#task_supply_'+x).wymeditor(
    skin: 'compact'
    logoHtml: '',
    toolsItems: [
        {'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},
        {'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},
        {'name': 'Indent', 'title': 'Indent', 'css': 'wym_tools_indent'},
        {'name': 'Outdent', 'title': 'Outdent', 'css': 'wym_tools_outdent'},
        {'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},
        {'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'},
        {'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'},
        {'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'},
        {'name': 'Preview', 'title': 'Preview', 'css': 'wym_tools_preview'}
    ])
root.addTaskPlan =  (x) -> 
  $('.links').before('<tr class="ts"> <td><textarea class="taskplan" id="task_triplet_'+x+'" name="task_triplet['+x+']"></textarea></td><td><a href="#" onclick=" $(this).parent().parent().remove(); return false;"><img alt="Close" src="/assets/close.png"></a></td></tr>')
  $('#task_triplet_'+x).wymeditor(
    skin: 'compact'
    logoHtml: '',
    toolsItems: [
        {'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},
        {'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},
        {'name': 'Indent', 'title': 'Indent', 'css': 'wym_tools_indent'},
        {'name': 'Outdent', 'title': 'Outdent', 'css': 'wym_tools_outdent'},
        {'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},
        {'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'},
        {'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'},
        {'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'},
        {'name': 'Preview', 'title': 'Preview', 'css': 'wym_tools_preview'}
    ])
      

