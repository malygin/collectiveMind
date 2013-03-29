#= require jquery
#= require jquery_ujs
#= require_tree .
#= require tinymce

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
