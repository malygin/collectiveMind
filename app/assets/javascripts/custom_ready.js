$(document).ready(function () {

    /* tooltips for all stages */
    $("#tooltip_button_1").click(function() {
        if ($(this).text()==' Открыть подсказки')
            $(this).html($(this).find('i')).append(' Закрыть подсказки')
        else $(this).html($(this).find('i')).append(' Открыть подсказки');
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

    /* show hint for question on 1st stage  */
    $('.notice-button').click(function(){
        $('#hint_question_'+$(this).data('question')).removeClass('close-notice');
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

});