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
root = exports ? this

root.addTask =  (x) -> 
  $('.links').before('<tr class="ts">  <td><textarea class="wymeditor" id="task_supply_'+x+'_1" name="task_supply['+x+'][1]"></textarea></td>    <td><a href="#" onclick=" $(this).parent().parent().remove(); return false;"><img alt="Close" src="/assets/close.png"></a></td></tr>')

  $(".wymeditor").wymeditor ->
    stylesheet: 'styles.css',
    postInit: (wym) ->
      $(wym._box).removeClass("wym_area_right")
      $(wym._box).find(wym._options.iframeSelector).css('height', '800px')
      

