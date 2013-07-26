$(document).ready(
     function(){
          $("a#add_aspect_for_concept")
          .bind("ajax:beforeSend",function(event, xhr, settings){
			settings.url += "?aspect_id="+$('#aspect_id').val();
		   });
         $( "#accordion_concept" ).accordion({
             collapsible: true,
             heightStyle: "content"
         });

});

function change_name_concept(id){
    if ($('#correct_disc_'+id+'_name').val()!= ''){
        $('#name_'+id).text($('#correct_disc_'+id+'_name').val());
    }

}
function remove_discontent(id){
	$("#"+id).remove();
}