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

        $('span#count_vote').text(i+"")   
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
    $('.task_supply ol li ul ').before('<br/><span class="task_supply_resource">Ресурсы:</span>')
   
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
        {'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'}
    ])

      

