/* Your JS codes here */
$(document).ready(function () {

    /* number colors for aspects and imperfects (class '.color_me') */
    var colors_aspect_codes = [
        'cfa7cc',
        'a4b1db',
        '88a2c3',
        '8a99ae',
        '8abdea',
        '8fc8d3',
        'a3bead',
        'a5cba2',
        'b9dd9d',
        'd7d69e',
        'e9dd93',
        'e7b288',
        'd59d9e'
    ];
    var colors_imperf_codes = [
        'd3a5c9',
        'a7b3dd',
        '87a9f3',
        '8d9caf',
        '85dbf2',
        '91c5d0',
        '8ad2be',
        'a6d1a6',
        'd7d49d',
        'f3e47d',
        'f9bf91',
        'eca3b7',
        'e67092',
        '6ea3f1',
        'a5bdad',
        '81dad6',
        '96afb6',
        'be85ca',
        'fbcd82',
        '79889b',
        'd3e18c',
        'eea266',
        'b7e3f0',
        '7dc7f6',
        'f7947f',
        'e2de95',
        '8fbce5',
        '7181d9',
        'b9daa3',
        'dc7674',
        '77b7f5',
        'ff7b67',
        'e8aa79',
        'd0596c',
        'ac87bd',
        'e89ec3',
        'feb497',
        'b67c94',
        '8790d3',
        '89b5f4',
        'b46a6b',
        'ff8f5f',
        '88a0ce',
        'cd97c9',
        '7391da',
        'fdaa68',
        'b45f58',
        '8fb5e6',
        'fea1cd',
        '978ac2'
    ];


    /*
    * data-me-type - aspect or imperfect
    * data-me-action - css property
    * data-me-color - item number in list
    * */

    $('.color_me').each(function(){ /* paints '.color_me' */
        var me = $(this);
        var type = me.attr('data-me-type');
        if (type === 'aspect') {
            var color = colors_aspect_codes[me.attr('data-me-color')];
        } else if (type === 'imperf'){
            var color = colors_imperf_codes[me.attr('data-me-color')];
        }
        var action = me.attr('data-me-action');
        color_item(me, action, color);
    });

    function color_item (object, action, color) {
        object.css(action, '#' + color);
    }


    /* post colored stripes */

    $('.post-theme').each(function(){
        curId = $(this).attr('id');
        $(this).width(count_themes_width (curId));
    });

    $('.post-theme').hover(function () {
        curId = $(this).attr('id');
        $('#' + curId + " .tag-stripes").hover(function () {
            $('#' + curId + " .tag-stripes").removeClass('active');
            $(this).addClass('active');
        });
    });

    $('.post-theme').mouseover(function(){
        $(this).addClass('shown');
        $(this).closest('.themes_cont').addClass('themesShown');
    });

    $('.post-theme').mouseleave(function(){
        $(this).removeClass('shown');
        $(this).closest('.themes_cont').removeClass('themesShown');
    });

    $('.tag-stripes').mouseover(function(){
        $(this).closest('.post-theme').width(count_themes_width($(this).closest('.post-theme').attr('id')));
    });


    function count_themes_width (cont) {
        var width = 0;
        $('#' + cont + ' .tag-stripes').each(function(){
            width = width + $(this).outerWidth();
        });
        return width + 100;
    }



    /* sort button active */
    $('.sort_btn').click(function(){
        $('.sort_btn').removeClass('active');
        $(this).addClass('active');
    });


    /* dropdown window */
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


    /* comments expandable column */
    $('.expand_button').click(function(){
        var col = $(this).attr('data-col');
        $('.popup_expandable_col').toggleClass('col-md-' + col).toggleClass('col-md-12').toggleClass('exp');
        $('.popup_expandable_col.ps_cont').perfectScrollbar('update');
    });

    $('.comment_col .collapse').on('shown.bs.collapse', function () {
        $('.popup_expandable_col.ps_cont').perfectScrollbar('update');
    });
    $('.comment_col .collapse').on('hidden.bs.collapse', function () {
        $('.popup_expandable_col.ps_cont').perfectScrollbar('update');
    });

    $('.answers_collapse').click(function(){
        $(this).toggleClass('opened');
    });

    $('.com_answers').on('shown.bs.collapse', function () {
        $('.modal_content.ps_cont').perfectScrollbar('update');
    });
    $('.com_answers').on('hidden.bs.collapse', function () {
        $('.modal_content.ps_cont').perfectScrollbar('update');
    });


    /* comments like/dislike active */
    $('.rate_button').click(function(){
        var me = $(this);
        if (!me.hasClass('pushed')){
            me.addClass('pushed');
            me.siblings('.rate_button').removeClass('pushed');
        } else {
            me.removeClass('pushed');
        }
    });


    /* vote popup init and fix size */
    $('.open-popup-vote-link').magnificPopup({
        type: 'inline',
        midClick: true
    });
    $('.open-popup-vote-link').on('mfpOpen', function(e) {
        var pane_h = $('.popup-vote .tab-pane.active').innerHeight();
        $('.popup-vote .tab-pane').each(function(){
            $(this).css('height', pane_h+'px');
        });
    });



    /* tooltips */
    $("#tooltip_button_1").click(function() {
		if ($(this).text()==' Открыть подсказки')
			$(this).html($(this).find('i')).append(' Закрыть подсказки')
		else $(this).html($(this).find('i')).append(' Открыть подсказки');

			
		
        $(".tooltip1").tooltip('toggle');
		$(this).toggleClass('btn-tooltip btn-tooltip-close')
    });

    $("[data-toggle=popover]").popover();

    $("[data-toggle=tooltip]").tooltip();

    $(".tt_def_shown").tooltip('show');


    /* submit на внешней кнопке в попапе с опросом */
    $('#a-submit-int1').click(function () {
        $('#interview-form1').submit();
    });



     /* MagnificPopup init */
    $('.open-popup-link').magnificPopup({
        type: 'inline',
        midClick: true,
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


    /* progress bar 6th stage */
    $('.pb-animated').waypoint(function (down) {
        if (!$(this).hasClass('pb-stop')) {
            setTimeout(function () {
                $('.pb-animated').each(function () {
                    var me = $(this);
                    var perc = me.attr("data-pbmax");
                    var current_perc = 0;
                    var progress = setInterval(function () {
                        if (current_perc >= perc) {
                            clearInterval(progress);
                            me.children('.pb-limit').html(me.attr("data-pbmax") + '%');
                            if(perc < 24){
                                padd_str = perc*3 + 'px';
                                if(perc < 5){
                                    padd_str = perc*10 + 'px';
                                }
                                me.children('.pb-limit').css('position', 'absolute');
                                me.children('.pb-limit').animate({
                                    left: padd_str}, 600);
                                me.children('.pb-limit').addClass('font_red');
                            }
                        } else {
                            current_perc += 2;
                            me.css('width', (current_perc) + '%');
                            me.children('.pb-limit').html(current_perc + '%');
                        }
                    }, 40);
                    $('.pb-animated').addClass('pb-stop');
                });
            }, 0);
        }
    }, {offset: '100%'});


    /* vertical bar in graphic 6th stage */
    $('.panel-graph-vertical-bar').each(function () {
        var me = $(this);
        var bar_h = me.attr("data-limit");
        switch (bar_h) {
            case 'max':
                me.css('height', '80px');
                break;
            case 'middle':
                me.css('height', '45px');
                break;
            case 'min':
                me.css('height', '10px');
                break;
            default:
                me.css('height', '0px');
        }
    });
});


/* carousel on end-stage */
$(function () {
    $('#myCarousel').carousel({
        interval: false
    });
    $('#myCarousel').on('slid', function () {
        var to_slide = $('.carousel-item.active').attr('data-slide-no');
        $('.myCarousel-target.active').removeClass('active');
        $('.list_win [data-slide-to=' + to_slide + ']').addClass('active');
    });
    $('.myCarousel-target').on('click', function () {
        $('#myCarousel').carousel(parseInt($(this).attr('data-slide-to')));
        $('.myCarousel-target.active').removeClass('active');
        $(this).addClass('active');
    });
    $('.myCarousel-contol').on('click', function () {

    });
});


/* questions carousels */
$(function () {
    $('.questionsCarousel').carousel({
        interval: false
    });
    $('.questionsCarousel').on('slid', function () {
        var to_slide = $(this).find('.carousel-item.active').attr('data-slide-no');
        $(this).find('.questionsCarousel-target.active').removeClass('active');
        $(this).find('.questionsCarousel-target[data-slide-to=' + to_slide + ']').addClass('active');
    });
    $('.questionsCarousel-target').on('click', function () {
        var carousel_id = get_carousel_id($(this));
        $(carousel_id).carousel(parseInt($(this).attr('data-slide-to')));
        $(carousel_id + ' .questionsCarousel-target.active').removeClass('active');
        $(this).addClass('active');
    });
    function get_carousel_id(obj){
        return $(obj).parents('.questionsCarousel').attr('id');
    }
});

/* equals active aspect and question blocks */


equal_heights();

$('.c1-item a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    equal_heights();
});
$('.aspects_tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    equal_heights();
});
$('.questionsCarousel').on('slid.bs.carousel', function (e) {
    equal_heights();
});

function equal_heights () {
    $('.main-pane.active .aspect-main-block').height('');
    $('.main-pane.active .aspect-questions-block').height('');
    var pane_one_h = $('.main-pane.active .aspect-main-block').height();
    var pane_two_h = $('.main-pane.active .aspect-questions-block').height();
    var new_h = tabs_height(pane_one_h, pane_two_h);
    $('.main-pane.active .aspect-main-block').height(new_h);
    $('.main-pane.active .aspect-questions-block').height(new_h);
}

function tabs_height (one_h, two_h) {
    return Math.max(one_h, two_h);
}



/* Knob */
$(document).ready(function () {
    $(function () {
        $(".knob").knob({
            width: 36,
            height: 36,
            readOnly: true
        });
    });
});
$(document).ready(function () {
    $('.knob').each(function () {
        var cur = $(this);
        // Knob counting script
        if (cur.val() == 0) {
            $({value: 0}).animate({value: cur.attr("data-end")}, {
                duration: 2800,
                easing: 'swing',
                step: function () {
                    cur.val(Math.ceil(this.value)).trigger('change');
                    cur.val(cur.val() + '%');
                }
            })
        }
    });

});


/* equals 1st stage slider items' height */
$(document).ready(function () {
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


/* questions block 1st stage, answer button script */
$(document).ready(function () {
    $('.answer-button').click(function () {
        var q_href = $(this).attr('href');
        $('.answer-button').each().removeClass('active');
        $(q_href).addClass('active');
    });
});



/* popup links and fix height */

    $('.open-popup').each(function () {
        me = $(this);
        var stageNum = me.attr('data-placement');
        var popupNum = me.attr('data-target');
        var src = '#popup-' + stageNum + '-' + popupNum;
        me.magnificPopup({
            type: 'inline',

            items: [
                {
                    src: src, // CSS selector of an element on page that should be used as a popup
                    type: 'inline'
                }
            ],
            callbacks: {
                open: function() {
                    /*$('.modal_content', this).height()*/
                    var me_id = $.magnificPopup.instance['items'][0]['src'];
                    var pop_h = $('.modal_content', me_id).height();
                    $('.modal_content', me_id).css({
                        'height': pop_h + 'px',
                        'overflow': 'hidden'
                    });
                },
                close: function() {
                    // Will fire when popup is closed
                }
            }
        });
    });


/* vote scripts */
$(document).ready(function () {
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

});


/* show comments panel on post hover */
$('.ch_action').hover(function(){
    var ch_id = $(this).attr('data-for');
    $('.comments_icon[data-for= "' + ch_id + '"]').toggleClass('active');
    $('#' + ch_id).toggleClass('active');
});



/* slide panel 3rd stage */
$('#opener').on('click', function() {
    var panel = $('#slide-panel');
    if (panel.hasClass("visible")) {
        panel.removeClass('visible').animate({'margin-left':'-400px'});
    } else {
        panel.addClass('visible').animate({'margin-left':'0px'});
    }
    return false;
});
$('#bottom-opener').on('click', function() {
    var panel = $('#bottom-panel');
    if (panel.hasClass("visible")) {
        panel.removeClass('visible').animate({'top':'100%'});
        $(this).toggleClass('fa-rotate-180');
    } else {
        var offset = $('.bottom_panel_stop').offset();
        var marg_offset = $('.bottom_fix .cont_heading').innerHeight();
        panel.addClass('visible').animate({'top':offset.top + marg_offset + 'px'});
        $(this).toggleClass('fa-rotate-180');
    }
    return false;
});


/* cabinet 3rd stage check-and-push */
var ch_its = $('.item', '.checked_items').length;
var unch_its = $('.item', '.unchecked_items').length;
$('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");

$('.check_push_box').click(function(){
    if ($(this).is(':checked')){
        var item = $(this).closest('.item').detach();
        $('.checked_items').append(item);
        ch_its++; unch_its--;
        $('.hideable_checks').show();
        $('.enter_lenght .ch_lenght').empty().append("(" + ch_its + ")");
        $('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");
    } else {
        var item = $(this).closest('.item').detach();
        $('.unchecked_items').append(item);
        ch_its--; unch_its++;
        if (ch_its == 0) {
            $('.hideable_checks').hide();
        }
        $('.enter_lenght .unch_lenght').empty().append("(" + unch_its + ")");
    }
});

/* toggle arrows on accordion */
$('.with_arrow').click(function(){
    $(this).find('i.collapse_arrow').toggleClass('fa-rotate-90');
});

/* cabinet sticker */
function close_sticker (id) {
    $(id).hide();
}
function open_sticker (id) {
    $(id).show();
}

$('.open_sticker').click(function(){
    var stick_id = $(this).attr('data-for');
    open_sticker(stick_id);
});
$('.sticker_close').click(function(){
    var stick_id = $(this).attr('data-for');
    close_sticker(stick_id);
});


/* append close button */
$(document).ready(function () {
    $('.cab_notice').append('<i class="fa fa-times cabnot_close"></i>');
    $('.cabnot_close').click(function(){
        $(this).closest('.cab_notice').hide();
    });
});


/* button toggle */
$(document).ready(function () {
    $('.btn_toggle').click(function(){
        var usg = $(this).attr('data-usage');
        $('.btn_toggle[data-usage=' + usg + ']').removeClass('active');
        $(this).addClass('active');
    });
});


/* textarea toggle */
$(document).ready(function () {
    $('.edit_tgl_ta').click(function(){
        var textarea_id = $(this).attr('data-for');
        alert(textarea_id);
        $(textarea_id).addClass('shown');
    });
});



/* help popover */
$(document).ready(function(){
    var data = 'Прочитайте все статьи по каждому из аспектов базы знаний и согласитесь (или не согласитесь) с их целесообразностью.<br>' +
        'Обратите внимание: раздел ”Введение в процедуру” — это не аспект, а просто введение в процедуру!';
    var popoverTemplate = ['<div class="popover help_popover_content cl_btn_container">',
        '<div class="arrow"></div>',
        '<i class="fa fa-times cl_btn font_white" onclick="$(&quot;.help_popover&quot;).popover(&quot;hide&quot;);"></i>',
        '<div class="popover-content font_white">',
        '</div>',
        '</div>'].join('');
    $(".help_popover").popover({
        selector: '[rel=popover]',
        trigger: 'manual',
        placement:'bottom',
        container: 'body',
        content:data,
        template:popoverTemplate,
        html:true
    });
    $(".help_popover").on("show.bs.popover", function () {
        $(this).addClass('shown');
    });
    $(".help_popover").on("hide.bs.popover", function () {
        $(this).removeClass('shown');
    });
    $(".help_popover").hover(function(){
        if (!$(this).hasClass('shown')) {
            $(".help_popover").popover('show');
        }
    });


    /*
    $('.add_pop_close_btn_here').append('<i class="fa fa-times cl_btn"></i>').removeClass('.add_pop_close_btn_here').addClass('cl_btn_container');
    $('.cl_btn').click(function(){
        $(this).closest('.cl_btn_cont').hide();
    });

    */



    /* rating cell bigger - */
    $('.rating_cell:contains("-")').css('font-size', '20px');



    /* popup digest btn */
    $(".btn_dia").click(function() {
        if ($(this).text() == 'Подробнее')
            $(this).html($(this).find('i')).append('Свернуть');
        else $(this).html($(this).find('i')).append('Подробнее');
        $('.dia_icon').toggleClass('active');
        $('.dia_legend').toggleClass('active');
    });


});