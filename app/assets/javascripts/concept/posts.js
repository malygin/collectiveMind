$(document).ready(
     function(){
          $("a#add_aspect_for_concept")
          .bind("ajax:beforeSend",function(event, xhr, settings){
			settings.url += "?aspect_id="+$('#aspect_id').val();
		   });
});

function remove_discontent(id){
	$("#"+id).remove();
}