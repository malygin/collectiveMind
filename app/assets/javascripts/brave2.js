document.addEventListener( "DOMContentLoaded", first_stage_slider, false );

//$(document).ready(function (){
function first_stage_slider() {

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
                prev_item(outer_w, offset);
            } else if(right_pos < (offset+outer_w)){

            } else {
                next_item(outer_w, offset)
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

};