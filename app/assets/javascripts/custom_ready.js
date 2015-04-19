$(document).ready(function () {

    /* tooltips for all stages */
    $("#tooltip_button_1").click(function() {
        if ($(this).text().trim()=='Открыть подсказки')
            $(this).html($(this).find('i')).append('Закрыть подсказки')
        else $(this).html($(this).find('i')).append('Открыть подсказки');
        $(".tooltip1").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close')
    });

    $("[data-toggle=popover]").popover();
    $("[data-toggle=tooltip]").tooltip();


    /*knob init */
    $(".knob").knob({
        width: 36,
        height: 36,
        readOnly: true
    });
    animateKnobChange(".knob");



    /* MagnificPopup init */
    $('.open-popup-link').magnificPopup({
        type: 'inline',
        midClick: true
    });
    /* welcome popup */
    $('.open_welcome_popup').magnificPopup({
        type: 'inline',
        midClick: true
    });
    /* magnific popup close button */
    $('.close_magnific').click(function(){
        var magnificPopup = $.magnificPopup.instance;
        magnificPopup.close();
    });


    /* questions carousels for 1 stage */
    $('.questionsCarousel').carousel({
        interval: false
    });

    /* show vote popup if stage is appropriate  */
    if ($('.popup-vote').length){
        $.magnificPopup.open({
            items: {src: '.popup-vote'},
            type: 'inline',
            //absolute prohibition on closing
            closeOnContentClick: false,
            closeOnBgClick: false,
            closeBtnInside: false,
            showCloseBtn: false,
            enableEscapeKey: false
        });
    };

    /* show welcome popup if stage is beginning  */
    if ($($('.open_welcome_popup').attr('href')).length){
        if (!$($('.open_welcome_popup').attr('href')).hasClass('shown_intro')){
            $('.open_welcome_popup').magnificPopup('open');
        }
    };


    /* show hint for question on 1st stage  */
    $('.notice-button').click(function(){
        $('#hint_question_'+$(this).data('question')).removeClass('close-notice');
    });
    /* close hint for question on 1st stage  */
    $('.close-button,.answer-button,.li_aspect').click(function(){
        $('.hint').addClass("close-notice");
    });

    /* dropdown window */
    // открытие/закрытие новостей эксперта -> перевести в simple popover
    $('.drop_opener').click(function(){
        var me = $(this);
        var dd_open_id = me.attr('data-dd-opener');
        var dd_win = $('#' + dd_open_id);
        if (me.hasClass('active')){
            close_dd(me, dd_win);
        } else {
            open_dd(me, dd_win);
        }
    });
    $('.dd_close').click(function(){
        var me = $(this);
        var dd_close_id = me.attr('data-dd-closer');
        var dd_opener = $('.drop_opener[data-dd-opener=' + dd_close_id + ']');
        var dd_win = $('#' + dd_close_id);
        close_dd(dd_opener, dd_win);
    });
    function open_dd(opener, win){
        opener.addClass('active');
        win.addClass('active');
    }
    function close_dd(opener, win){
        opener.removeClass('active');
        win.removeClass('active');
        win.find('.collapse.in').removeClass('in');
        win.find('[data-toggle="collapse"]').addClass('collapsed');
    }

    //$('.ch_action').hover(function(){
    //    var ch_id = $(this).attr('data-for');
    //    $('.comments_icon[data-for= "' + ch_id + '"]').toggleClass('active');
    //    $('#' + ch_id).toggleClass('active');
    //});

   // одинаковая высота для аспектов в слайдере на первом этапе - переделать в цсс
    var max_item_h = 0;
    $('.c1-item').each(function () {
        var cur_height = $(this).innerHeight();
        if (cur_height > max_item_h) {
            max_item_h = cur_height;
        }
    });
    $('.c1-item-inner').each(function () {
        $(this).css('height', max_item_h + 'px');
    });
    $('.client-one .owl-nav').css('height', max_item_h + 'px');

    var wrapper_w = 0;
    $('.owl-item').each(function () {
        wrapper_w += $(this).innerWidth();
    });
    var content_w = $('.owl-carousel').innerWidth()
    if (wrapper_w < content_w) {
        $('.nav-tabs').css('padding', '0');
        $('.owl-nav').css('display', 'none');
    }




    /* слайдер для аспектов для 1 стадии */
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



});