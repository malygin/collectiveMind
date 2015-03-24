/* Your JS codes here */
$(document).ready(function () {

    /* popup fix size */
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

    /* vote progress-bar */

    var vote_progr = $('.vote_progress').attr('data-limit');
    $('.vote_progress').css('width', vote_progr + '%');

    /* vote 1st stage */

    function handleDragStart(e) {
        this.style.opacity = '0.6';  // this / e.target is the source node.
    }

    function handleDragOver(e) {
        if (e.preventDefault) {
            e.preventDefault(); // Necessary. Allows us to drop.
        }

        e.dataTransfer.dropEffect = 'move';  // See the section on the DataTransfer object.

        return false;
    }

    function handleDragEnter(e) {
        // this / e.target is the current hover target.
        this.classList.add('over');
    }

    function handleDragLeave(e) {
        this.classList.remove('over');  // this / e.target is previous target element.
    }

    var vote_items = document.querySelectorAll('.votable_item');
    [].forEach.call(vote_items, function(vote_item) {
        vote_item.addEventListener('dragstart', handleDragStart, false);
        vote_item.addEventListener('dragover', handleDragOver, false);
    });
    var vote_polls = document.querySelectorAll('.votable_poll');
    [].forEach.call(vote_polls, function(vote_poll) {
        vote_poll.addEventListener('dragenter', handleDragEnter, false);
        vote_poll.addEventListener('dragleave', handleDragLeave, false);
    });

    $('.close_magnific').click(function(){
        var magnificPopup = $.magnificPopup.instance;
        magnificPopup.close();
    });

    /* badge comments */
    $('.badge_comments').click(function(){
        if (!$(this).hasClass('active')) {
            $('.badge_comments').each(function () {
                $(this).removeClass('active');
            });
            $(this).addClass('active');
        };
    });

    /* tooltips */
    $("#tooltip_button_1").click(function() {
        $("#tooltip1_1").tooltip('show');
        $("#tooltip1_2").tooltip('show');
        $("#tooltip1_3").tooltip('show');
        $("#tooltip1_4").tooltip('show');
        $("#tooltip1_5").tooltip('show');
        $(this).hide();
        $("#close_tooltip_button_1").show();
    });
    $("#close_tooltip_button_1").click(function() {
        $("#tooltip1_1").tooltip('destroy');
        $("#tooltip1_2").tooltip('destroy');
        $("#tooltip1_3").tooltip('destroy');
        $("#tooltip1_4").tooltip('destroy');
        $("#tooltip1_5").tooltip('destroy');
        $(this).hide();
        $("#tooltip_button_1").show();
    });
    $("#tooltip_button_2").click(function() {
        $("#tooltip2_1").tooltip('show');
        $("#tooltip2_2").tooltip('show');
        $("#tooltip2_3").tooltip('show');
        $("#tooltip2_4").tooltip('show');
        $(this).hide();
        $("#close_tooltip_button_2").show();
    });
    $("#close_tooltip_button_2").click(function() {
        $("#tooltip2_1").tooltip('destroy');
        $("#tooltip2_2").tooltip('destroy');
        $("#tooltip2_3").tooltip('destroy');
        $("#tooltip2_4").tooltip('destroy');
        $(this).hide();
        $("#tooltip_button_2").show();
    });
    $("#tooltip_button_3").click(function() {
        $("#tooltip3_1").tooltip('show');
        $("#tooltip3_2").tooltip('show');
        $(this).hide();
        $("#close_tooltip_button_3").show();
    });
    $("#close_tooltip_button_3").click(function() {
        $("#tooltip3_1").tooltip('destroy');
        $("#tooltip3_2").tooltip('destroy');
        $(this).hide();
        $("#tooltip_button_3").show();
    });
    $("#tooltip_button_4").click(function() {
        $("#tooltip4_1").tooltip('show');
        $(this).hide();
        $("#close_tooltip_button_4").show();
    });
    $("#close_tooltip_button_4").click(function() {
        $("#tooltip4_1").tooltip('destroy');
        $(this).hide();
        $("#tooltip_button_4").show();
    });

    $(".b-tooltip").tooltip();

    $(".b-popover").popover();

    $("[data-toggle=popover]").popover();

    $(".popover_news").click(function(){
        $(".news-popup-href").magnificPopup({});
    });

    $(".owl-carousel").owlCarousel({
        slideSpeed : 500,
        rewindSpeed : 1000,
        mouseDrag : true,
        stopOnHover : true
    });
    /* Own navigation */
    $(".owl-nav-prev").click(function(){
        $(this).parent().next(".owl-carousel").trigger('owl.prev');
    });
    $(".owl-nav-next").click(function(){
        $(this).parent().next(".owl-carousel").trigger('owl.next');
    });
    /* чтобы работало две карусели на одной странице */
    var owl1 = $("#owl-vote-1");
    $("#owl-vote-1").owlCarousel({
        autoPlay: false,
        stopOnHover: true,
        paginationSpeed: 1000,
        paginationNumbers: true,
        goToFirstSpeed: 2000,
        singleItem: true,
        autoHeight: true,
        transitionStyle: "fade",
        touchDrag: false,
        mouseDrag: false
    });
    $("#owl-arrow-left-1").click(function () {
        owl1.trigger('owl.prev');
    });
    $("#owl-arrow-right-1").click(function () {
        owl1.trigger('owl.next');
    });

    var owl2 = $("#owl-vote-2");
    $("#owl-vote-2").owlCarousel({
        autoPlay: false,
        stopOnHover: true,
        paginationSpeed: 1000,
        paginationNumbers: true,
        goToFirstSpeed: 2000,
        singleItem: true,
        autoHeight: true,
        transitionStyle: "fade",
        touchDrag: false,
        mouseDrag: false
    });
    $("#owl-arrow-left-2").click(function () {
        owl2.trigger('owl.prev');
    });
    $("#owl-arrow-right-2").click(function () {
        owl2.trigger('owl.next');
    });



    /* submit на внешней кнопке в попапе с опросом */
    $('#a-submit-int1').click(function () {
        $('#interview-form1').submit();
    });


    /* подсказка */
    $('.hint .close-button').click(function () {
        $('.hint').addClass("close-notice");
    });

    //$('.notice-button').click(function () {
    //    $('.hint').removeClass("close-notice");
    //});

    /* #hashtag new_code */
    $('.notice-button').click(function(){
        var questionId;
        questionId = $(this).data('question');
        $('.hint#hint_question_'+questionId).removeClass("close-notice");
    });


    /* неверный ответ */
    $('.wrong-answer .close-button').click(function () {
        $('.wrong-answer').addClass("close-notice");
    });

    $('.answer-button').click(function () {
        $('.wrong-answer').removeClass("close-notice");
    });

    /* #hashtag new_code */
    $('.li_aspect button[data-toggle="tab"]').on('show.bs.tab', function (e) {
        $('.wrong-answer').addClass("close-notice");
    });


    /* вывод замечания при наведении на знак */
    $('.admin-notice-sign').hover(function () {
        $('.admin-notice-displayable').addClass("show");
    });
    $('.close-admin-button').click(function () {
        $('.admin-notice-displayable').removeClass("show");
    });



    /* цветные полоски с тегами в нововведении */
    var curId;
    $("a.tag-stripe").hover(function () {
        curId = $(this).parent().attr('id');
        $('#' + curId + " a.tag-stripe").removeClass('active');
        $(this).addClass('active');
    });


    /* MagnificPopup */
    $('.open-popup-link').magnificPopup({
        type: 'inline',
        midClick: true
    });


    /* активация и деактивация кнопки "Проголосовать" */

    function checkButtonStatement(value, button) {
        if (value) {
            if (button.disabled) {
                button.disabled = false;
            }
        } else {
            button.disabled = true;
        }
    };

    /* для того, чтобы работало несколько на одной странице */
    var voteButton1 = document.getElementById("vote-button1");
    var voteButton2 = document.getElementById("vote-button2");

    var numSelected1 = 0;
    $('.drag1').click(function () {
        ($(this).hasClass("selected")) ? --numSelected1 : ++numSelected1;
        checkButtonStatement(numSelected1, voteButton1);
        $(this).toggleClass("selected");
    });

    var numSelected2 = 0;
    $('.drag2').click(function () {
        ($(this).hasClass("selected")) ? --numSelected2 : ++numSelected2;
        checkButtonStatement(numSelected2, voteButton2);
        $(this).toggleClass("selected");
    });
});
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
});

$(function () {
    $('.questionsCarousel').carousel({
        interval: false
    });
    //$('.questionsCarousel').on('slid', function () {
    //    var to_slide = $(this).find('.carousel-item.active').attr('data-slide-no');
    //    $(this).find('.questionsCarousel-target.active').removeClass('active');
    //    $(this).find('.questionsCarousel-target[data-slide-to=' + to_slide + ']').addClass('active');
    //});
    //$('.questionsCarousel-target').on('click', function () {
    //    var carousel_id = get_carousel_id($(this));
    //    $(carousel_id).carousel(parseInt($(this).attr('data-slide-to')));
    //    $(carousel_id + ' .questionsCarousel-target.active').removeClass('active');
    //    $(this).addClass('active');
    //});
    //function get_carousel_id(obj){
    //    return $(obj).parents('.questionsCarousel').attr('id');
    //}
});

/* used in first stage*/
var pane_h = $('.main-pane.in .aspect-main-block').height();
$('.main-pane.in .aspect-questions-block').css('height', pane_h + 74);
$('.aspects_tabs>li>a').click(function () {
    var id = $(this).attr('href');
    if (pane_h < $(id).innerHeight()){
        pane_h = $(id).innerHeight();
    }
    $(id).css('height', pane_h);
    $('.main-pane.in .aspect-questions-block').css('height', pane_h + 74);
});
/*$('.c1-item>a').click(function(){
 var id = $(this).attr('href');
 var pane_h = $(id + ' .aspect-main-block').height();
 $(id + ' .aspect-questions-block').css('height', pane_h + 74);
 }); */


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
$(document).ready(function () {
    $('.owl-item li a').click(function () {
        if (!$(this).closest('li').hasClass('active')) {
            $('.owl-item li').removeClass('active');
            $(this).closest('li').addClass('active');
        }
        ;
    });
});
$(document).ready(function () {
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
    ;
});

//$(document).ready(function () {
//    $('.answer-button').click(function () {
//        var q_href = $(this).attr('href');
//        $('.answer-button').each().removeClass('active');
//        $(q_href).addClass('active');
//    });
//});



/*used in second stage*/


$('.post-body').contenthover({
    overlay_width: 80,
    overlay_height: 180,
    effect: 'slide',
    slide_direction: 'right',
    overlay_x_position: 'right',
    overlay_y_position: 'center',
    overlay_opacity: 0.8
});

$('.open-popup').each(function () {
    me = $(this);
    var stageNum = me.attr('data-placement');
    var popupNum = me.attr('data-target');
    var src = '#popup-' + stageNum + '-' + popupNum;
    me.magnificPopup({
        items: [
            {
                src: src, // CSS selector of an element on page that should be used as a popup
                type: 'inline'
            }
        ],
        type: 'inline'
    });
});

$('.post-theme').hover(function () {
    curId = $(this).attr('id');
    $('#' + curId + " a.tag-stripes").hover(function () {
        $('#' + curId + " a.tag-stripes").removeClass('active');
        $(this).addClass('active');
    });
});


/* used in fifth stage*/


$(document).ready(function () {
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



/* right slide panel */
$('#opener').on('click', function() {
    var panel = $('#slide-panel');
    if (panel.hasClass("visible")) {
        panel.removeClass('visible').animate({'margin-right':'-305px'});
    } else {
        panel.addClass('visible').animate({'margin-right':'0px'});
    }
    $('.slide-opener i').toggleClass('fa-rotate-180');
    return false;
});

///* welcome popups */
//$(window).load(function () {
//    // retrieved this line of code from http://dimsemenov.com/plugins/magnific-popup/documentation.html#api
//    $('.welcome_popup').magnificPopup.open({
//        type: 'inline'
//
//        // You may add options here, they're exactly the same as for $.fn.magnificPopup call
//        // Note that some settings that rely on click event (like disableOn or midClick) will not work here
//    }, 0);
//});