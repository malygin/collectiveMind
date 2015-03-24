//document.addEventListener( "DOMContentLoaded", first_stage_slider, false );

//$(document).ready(function () {
//    $.ajax({
//        url:  "/users/select_users",
//        dataType: "json",
//        data: {
//            prezzario: ui.item.value
//        },
//        success: function(data) {
//            $('#usersList').append(data.users);
//        }
//    });
//});

function init_first_stage_knob() {
    var cur = $('#knob-1');
    // Knob counting script
    $({value: 0}).animate({value: cur.attr("data-end")}, {
        duration: 2800,
        easing: 'swing',
        step: function () {
            cur.val(Math.ceil(this.value)).trigger('change');
            cur.val(cur.val() + '%');
        }
    })
};

function init_first_stage_slider() {

    $('.tab-pane.fade.in').find('.aspect-questions-block').innerHeight();

    /*var max_right = 0;
     $('.tab-pane').change(function() {
     alert('in');
     if ($(this).hasClass('active')) {
     $(this).children('.aspect-questions-block').each(function () {
     var h = $(this).innerHeight();
     if (h > max_right) {
     max_right = h;
     }
     });
     }
     ;
     $(this).children('.aspect-questions-block').each(function () {
     $(this).css('height', max_right + 'px');
     });
     });*/

    var max_item_h = 0;
    $('.c1-item').each(function () {
        var cur_height = $(this).innerHeight();
        if (cur_height > max_item_h) {
            max_item_h = cur_height;
        }
        ;
    });
    $('.c1-item-inner').each(function () {
        $(this).css('height', max_item_h + 'px');
    });


    var offset = 0;

    /* set inner width */
    var inner = $('.slider-inner');
    var inner_w = count_inner()+100;
    inner.css('width', inner_w+'px');

    /* count outer width */
    var outer = $('.slider-outer');
    var outer_w = outer.innerWidth();

    /* events */
    $('.slider-item').click(function(){
        click_item($(this));
    });
    $('.slider-right').click(function(){
        slide_inner(outer_w, offset, 'right');
    });
    $('.slider-left').click(function(){
        slide_inner(outer_w, offset, 'left');
    });


    function count_inner(){
        var sliders_sum = 0;
        $('.slider-item').each(function (){
            sliders_sum += $(this).innerWidth();
        });
        return sliders_sum;
    };

    /*  */
    function slide_inner(out, off, dir){
        var sum_i = 0;
        var m = 0;
        var right_point = off + out;

        $('.slider-item').each(function (){
            var me = $(this);
            sum_i += me.innerWidth();
            if (dir == 'left' && off) {
                if (sum_i >= off) {
                    m = me.innerWidth() - (sum_i - off);
                    return false;
                }
            } else if (dir == 'right'){
                if (sum_i > right_point){
                    m = sum_i - right_point;
                    return false;
                }
            }
        });

        if(m){
            if (dir == 'left') {
                off -= m;
            } else if (dir == 'right') {
                off += m;
            }
            var anim = [];
            anim['margin-left'] = -off+'px';
            inner.animate(anim, 500);

            offset = off;
        }
    };

    function click_item(item) {
        if(!(item.hasClass('active'))){
            $('.slider-item').removeClass('active');
            item.addClass('active');
            var left_pos = count_pos()+1;
            var right_pos = left_pos + item.innerWidth();
            if (left_pos < offset){
                slide_inner(outer_w, offset, "left");
            } else if(right_pos < (offset+outer_w)){

            } else {
                slide_inner(outer_w, offset, "right");
            };
        };
    };

    function count_pos(){
        var sum_i = 0;
        var m = 0;
        $('.slider-item').each(function () {
            var me = $(this);
            if (me.hasClass('active')){
                return false;
            } else {
                sum_i += me.innerWidth();
            }
        });
        return sum_i;
    }

    //$('#aspects_spinner_tab').hide();
    //$('#first-stage-slider li').show();

};

$(document).ready(function () {
    var main = $('.open_welcome_popup');
    var link = main.attr('href');
    if (link) {
        main.magnificPopup({
            type: 'inline',
            midClick: true
        });

        var popup = $(link).attr('id');

        if (popup && !$(link).hasClass('shown_intro')) {
            main.magnificPopup('open');
        }
    }



    var main_vote = $('.popup-vote');
    var popup = main_vote.attr('id');
    if (popup) {
        magnificPopupOpen('#'+popup);
    }

});