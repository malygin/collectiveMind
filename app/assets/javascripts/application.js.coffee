#= require jquery
#= require jquery_ujs
#= require_tree
#= require jquery.ui.all

$(document).ready ->
    $(".voteBar")
      .bind "ajax:success", (event, resp) ->
        $(this).replaceWith "Вы проголосовали, спасибо!"
        i = $('span#count_vote').text() - 1
        $('span#count_vote').text(i)
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
#    $('.task_supply > ol > li > ul > li > ul ').before('<br/><span class="task_supply_resource">Средства создания:</span>')
   
root = exports ? this


