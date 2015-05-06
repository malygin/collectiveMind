$(document).ready(function () {

    /* tooltips for all stages */
    $("#tooltip_button_1").click(function() {
        if ($(this).hasClass('btn-tooltip')) {
            $(this).html($(this).find('i')).append('Закрыть подсказки');
        }
        else {
            $(this).html($(this).find('i')).append('Открыть подсказки');
        }
        $(".tooltip1").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close');
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
    //$('.open_welcome_popup').magnificPopup({
    //    type: 'inline',
    //    midClick: true
    //});
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
    //if ($($('.open_welcome_popup').attr('href')).length){
    //    if (!$($('.open_welcome_popup').attr('href')).hasClass('shown_intro')){
    //        $('.open_welcome_popup').magnificPopup('open');
    //    }
    //};
    if ($('.popup-explanation').length){
        if (!$('.popup-explanation').hasClass('shown_intro')){
            $.magnificPopup.open({
                items: {src: '.popup-explanation'},
                type: 'inline',
                //absolute prohibition on closing
                closeOnContentClick: false,
                closeOnBgClick: false,
                closeBtnInside: false,
                showCloseBtn: false,
                enableEscapeKey: false
            });
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
    /* close notice for question on 1st stage  */
    $('.answer-button,.li_aspect').click(function(){
        $('.notice').addClass("close-notice");
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

    //  табы в форме для идей в пакетах переключалка
    $('#tabs_form_navation a').click(function (e) {
        $('#tabs_form_navation a button.active').removeClass('active')
        $(this).children('button').addClass('active')
    });


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


    // скрипт для голосования
    var folder_len = {};
    var vote_icon_all = 'fa-home';

    $('[data-vote-poll-role]').each(function() {
        var role = $(this).attr('data-vote-poll-role');
        var len = count_vote_items($(this));
        folder_len[role] = len;
        $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text(len);
    });
    var pb = $('.vote_progress');
    var all_len = folder_len['overall'] = count_vote_items('.all_vote');
    pb_stretch(pb, all_len, folder_len['overall']);

    function count_vote_items (me){
        return $('.vote_item_cont', me).length;
    }

    function pb_stretch(me, current, over){
        var vote_perc = (1 - current/over)*100;
        me.css('width', vote_perc+'%');
    }

    $('.vote_button').click(function () {
        var role = $(this).attr('data-vote-role');
        if (!$(this).hasClass('voted')) {
            if ($(this).siblings().hasClass('voted')){
                var prev_role = $(this).siblings('.voted').attr('data-vote-role');
                $(this).siblings('.voted').each(function() {
                    $(this).removeClass('voted');
                    $('.fa', this).removeClass(vote_icon_all).addClass($(this).attr("data-icon-class"));
                });
            }
            $(this).addClass('voted');
            $('.fa', this).removeClass($(this).attr("data-icon-class")).addClass(vote_icon_all);
            var vote_item = $(this).parents('.vote_item_cont').detach();
            $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text(++folder_len[role]);
            if (prev_role) {
                $('[data-vote-folder-role = "' + prev_role + '"] > .vote_folder_inn > .vote_counter').text(--folder_len[prev_role]);
            } else {
                all_len--;
                $('[data-vote-folder-role = "all"] > .vote_folder_inn > .vote_counter').text(all_len);
                pb_stretch(pb, all_len, folder_len['overall']);
            }
            $('[data-vote-poll-role = "' + role + '"] .container>.row').append(vote_item);
        } else {
            $(this).removeClass('voted');
            $('.fa', this).removeClass(vote_icon_all).addClass($(this).attr("data-icon-class"));
            var vote_item = $(this).parents('.vote_item_cont').detach();
            $('[data-vote-folder-role = "' + role + '"] > .vote_folder_inn > .vote_counter').text(--folder_len[role]);
            $('.all_vote>.container>.row').append(vote_item);
            all_len++;
            $('[data-vote-folder-role = "all"] > .vote_folder_inn > .vote_counter').text(all_len);
            pb_stretch(pb, all_len, folder_len['overall']);
        }
        var item_e = $(this).parents('.item_expandable');
        if (item_e.hasClass('opened')){

            item_e.removeClass('opened');
            $(this).siblings('.vote_open_detail').children('i').toggleClass('fa-angle-right').toggleClass('fa-angle-left');
        }
    });

    $('.vote_open_detail').click( function (){
        $('i', this).toggleClass('fa-angle-right');
        $('i', this).toggleClass('fa-angle-left');
        $('.item_expandable').not($(this).parents()).removeClass('opened');
        $(this).parents('.item_expandable').toggleClass('opened');
    });




    var popoverTemplate = ['<div class="popover help_popover_content cl_btn_container">',
        '<div class="arrow"></div>',
        '<a data-remote="true" rel="nofollow" data-method="put" href="/project/' + $('.help_popover').data('project') + '/' + $('.help_popover').data('stage') + '/posts/check_field?check_field=' + $('.help_popover').data('status') + '&status=true">',
        '<i class="fa fa-times cl_btn font_white" onclick="$(\'.help_popover\').popover(\'hide\');"></i></a>',
        '<div class="popover-content font_white">',
        '</div>',
        '</div>'].join('');



    $(".help_popover").popover({
        selector: '[rel=popover]',
        trigger: 'manual',
        placement:'bottom',
        container: 'body',
        content: $('.help_popover').data('text'),
        template:popoverTemplate,
        html:true
    });

    if (!$($('.help_popover')).hasClass('shown_intro')){
        $('.help_popover').popover('show');
    }

    $(".help_popover").on("show.bs.popover", function () {
        $(this).addClass('shown');
    });
    $(".help_popover").on("hide.bs.popover", function () {
        $(this).removeClass('shown');
    });
    $(".help_popover").click(function(){
        if (!$(this).hasClass('shown')) {
            $(".help_popover").popover('show');
        }
    });



    /* cabinet 3rd stage check-and-push */
    var ch_its = $('.item', '.checked_items').length;
    var unch_its = $('.item', '.unchecked_items').length;
    $('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");

    $('.check_push_box').click(function(){
        var item = $(this).closest('.item').detach();
        var item_id = $(item).attr('data-id');
        $('#discontents').find('.item[data-id=' + item_id + ']').remove();
        $('#ideas').find('.item[data-id=' + item_id + ']').remove();
        $('.checked_items').find('.item[data-id=' + item_id + ']').remove();
        if ($(this).is(':checked')){
            $('.checked_items').append(item);
            ch_its++; unch_its--;
            $('.hideable_checks').show();
            $('.enter_lenght .ch_lenght').empty().append("(" + ch_its + ")");
            $('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");
            /*Для 4 стадии, при выборе идеи мы добавляем в форму поле с ид идеи*/
            if ($('#for_hidden_fields').length > 0) {
                $('#for_hidden_fields').append('<input id="novation_post_concept_' + item_id + '" name="novation_post_concept[]" type="hidden" value="' + item_id + '"/>');
                $('.selected_concepts').append('<p class="bold" id="selected_concept_' + item_id + '">' + $(item).find('a.collapser_type1').text() + '</p>');
            }
        } else {
            $('.unchecked_items').append(item);
            ch_its--; unch_its++;
            if (ch_its == 0) {
                $('.hideable_checks').hide();
            }
            $('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");
            /*Для 4 стадии, при выборе идеи мы добавляем в форму поле с ид идеи*/
            if ($('#for_hidden_fields').length > 0) {
                $('#for_hidden_fields').find('input#novation_post_concept_' + item_id).remove();
                $('.selected_concepts').find('p#selected_concept_' + item_id).remove();
            }
        }
    });


    // Открытие "Добавления задач" в кабинете проектов
    $('#bottom-opener').on('click', function () {
        console.log(111);
        var panel = $('#bottom-panel');
        if (panel.hasClass("visible")) {
            panel.removeClass('visible').animate({'top': '100%'});
            $(this).toggleClass('fa-rotate-180');
        } else {
            var offset = $('.bottom_panel_stop').offset();
            var marg_offset = $('.bottom_fix .cont_heading').innerHeight();
            panel.addClass('visible').animate({'top': offset.top + marg_offset + 'px'});
            $(this).toggleClass('fa-rotate-180');
        }
        return false;
    });

    $('a.scroll_tab').on('click', function (e) {
        var href = $(this).attr('href');
        $('.tab_cont5').animate({
            scrollTop: 0
        }, 'slow');
        e.preventDefault();
    });


});
