//= require jquery
//= require jquery_ujs
//= require_tree
//= require jquery.ui.all
//= require highcharts
//= require highcharts/highcharts-more
//= require selectize
//= require twitter/bootstrap




function get_life_tape_form(){
    $('#new_life_tape').css('display','block');
    $("#add_record").hide( "slow" );
    $("#new_life_tape").animate({
        height: 100
    }, "normal");
    $("#Send")
        .stop()
        .show()
        .animate({left:$('#new_life_tape').width() - 200 ,  opacity:1.000},{queue:false,duration:500});
}

function reset_life_tape_form(){
    $("#Send").animate({left:0 ,  opacity:0.000},{queue:false,duration:500});
    $("#new_life_tape").animate({
        height: 0
    }, "normal",  function() {
        $('#new_life_tape').css('display','none');
    });
    $("#add_record").show( "slow" );
}

