$(document).ready(
    function(){
        $("a#add_aspect_for_plan1")
            .bind("ajax:beforeSend",function(event, xhr, settings){
                settings.url += "?aspect_id="+$('#aspect_id').val();
            });
        $("a#add_aspect_for_plan2")
            .bind("ajax:beforeSend",function(event, xhr, settings){
                settings.url += "?plan_stage=1&aspect_id="+$('#aspect_id2').val();
            });
    });