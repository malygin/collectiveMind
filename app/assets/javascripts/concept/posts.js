$(document).ready(
     function(){
          $("a#add_aspect_for_concept")
          .bind("ajax:beforeSend",function(event, xhr, settings){
			settings.url += "?aspect_id="+$('#aspect_id').val();
		   });
         $('.wymeditor2').wymeditor({ skin: 'compact',logoHtml: '',toolsItems: [{'name': 'InsertOrderedList', 'title': 'Ordered_List',  'css': 'wym_tools_ordered_list'},{'name': 'InsertUnorderedList', 'title': 'список ресурсов', 'css': 'wym_tools_unordered_list'},{'name': 'Indent', 'title': 'На уровень вправо', 'css': 'wym_tools_indent'},{'name': 'Outdent', 'title': 'На уровень влево', 'css': 'wym_tools_outdent'}]});

         $( "#accordion_concept" ).accordion({
             collapsible: true,
             active: false,
             heightStyle: "content"
         });

});

function change_name_concept(id){
    if ($('#correct_disc_'+id+'_name').val()!= ''){
        $('#name_'+id).text($('#correct_disc_'+id+'_name').val());
    }

}
function remove_discontent(id){
    console.log('!!!!')
	$("#discontent_"+id).remove();
	$("#name_"+id).remove();
    $('#accordion_concept').accordion("refresh");
}