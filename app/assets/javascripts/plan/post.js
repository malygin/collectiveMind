$(document).ready(
    function(){
        $("a.add_aspect_for_plan")
            .bind("ajax:beforeSend",function(event, xhr, settings){
                console.log(event);
                settings.url += "?aspect_id="+$('#aspect_id').val();
            });


        $(".accordion").accordion({
            collapsible: true,
            heightStyle: "content",
            active: false
        });

    });


function load_new_aspect(id){
     cond= $('#aspect_'+id).val();
    if (!($('#accordion_concept_'+id).html().trim())){
        $.ajax({
            url: "/project/"+document.URL.split('/')[4]+"/plan/status/0/posts/"+id+"/add_aspect?cond_id="+cond,
            type : 'GET',
            dataType : 'script',
            context: document.body
        })
    }
}

function load_new_first_cond(id){
    cond= $('#pa_id').val();
        $.ajax({
            url: "/project/"+document.URL.split('/')[4]+"/plan/status/0/posts/"+id+"/add_first_cond?cond_id="+cond,
            type : 'GET',
            dataType : 'script',
            context: document.body
        })

}