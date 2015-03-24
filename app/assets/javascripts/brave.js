function magnificPopupOpen(tag){
    $.magnificPopup.open({
        items: {
            src: tag, // can be a HTML string, jQuery object, or CSS selector
                type: 'inline',
                midClick: true
            }
    });
};

function PanelVerticalBar(){
    $('.panel-graph-vertical-bar').each(function(){
        var me = $(this);
        var bar_h = me.attr("data-limit");
        switch(bar_h) {
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
};




$(document).ready(function() {
    $('.close-button').click(function(){
        $('.notice').addClass("close-notice");
    });
    $('.notice-button').click(function(){
        $('.notice').removeClass("close-notice");
    });
});


$(function() {

    setTimeout(function(){

        $('.fill-limit').each(function() {
            var me = $(this);
            var perc = me.attr("data-limit");
            var current_perc = -1;

            if(!$(this).hasClass('stop')){

                var progress = setInterval(function() {

                    if (current_perc>=perc) {
                        clearInterval(progress);
                    } else {
                        current_perc +=1;
                        me.parent().children().children('.filler').css('height', (current_perc/2)+'%');
                        me.html(current_perc+'<span>%</span>');
                    }

                }, 6);

                me.addClass('stop');
                me.parent().children().children('.filler').addClass('stop');

            }

        });

    }, 0);

});

//$(document).ready(function(){
//    // Way Points With Count To()
//    $('.number-count').waypoint(function(down){
//        if(!$(this).hasClass('stop-counter'))
//        {
//            $(this).countTo();
//            $(this).addClass('stop-counter');
//        }
//    }, {
//        offset: '90%'
//    });
//});
//
//jQuery(document).ready(function() {
//    jQuery('.r-slider .banner').revolution({
//        delay:7000,
//        startheight:400,
//        startwidth:1000,
//        startWithSlide:0,
//
//        fullScreenAlignForce:"off",
//        autoHeight:"off",
//
//        shuffle:"off",
//
//        onHoverStop:"on",
//
//        thumbWidth:100,
//        thumbHeight:50,
//        thumbAmount:3,
//
//        hideThumbsOnMobile:"on",
//        hideNavDelayOnMobile:1500,
//        hideBulletsOnMobile:"off",
//        hideArrowsOnMobile:"off",
//        hideThumbsUnderResoluition:0,
//
//        hideThumbs:10,
//        hideTimerBar:"on",
//
//        keyboardNavigation:"on",
//
//        navigationType:"bullet",
//        navigationArrows:"solo",
//        navigationStyle:"round",
//
//        navigationHAlign:"center",
//        navigationVAlign:"bottom",
//
//        soloArrowLeftHalign:"left",
//        soloArrowLeftValign:"center",
//        soloArrowLeftHOffset:20,
//        soloArrowLeftVOffset:0,
//
//        soloArrowRightHalign:"right",
//        soloArrowRightValign:"center",
//        soloArrowRightHOffset:20,
//        soloArrowRightVOffset:0,
//
//
//        touchenabled:"on",
//        swipe_velocity:"0.7",
//        swipe_max_touches:"1",
//        swipe_min_touches:"1",
//        drag_block_vertical:"false",
//
//        stopAtSlide:-1,
//        stopAfterLoops:-1,
//        hideCaptionAtLimit:0,
//        hideAllCaptionAtLilmit:0,
//        hideSliderAtLimit:0,
//
//        dottedOverlay:"none",
//
//        spinned:"spinner4",
//
//        fullWidth:"off",
//        forceFullWidth:"off",
//        fullScreen:"off",
//        fullScreenOffsetContainer:"#topheader-to-offset",
//    });
//});
//
//$(document).ready(function(){
//    $(function() {
//        $(".knob-one .knob").knob({
//            width: 150,
//            height: 150,
//            readOnly: true
//        });
//    });
//
//    $(function() {
//        $(".knob-two .knob").knob({
//            height: 160,
//            readOnly: true
//        });
//    });
//
//});
//
//
//$(document).ready(function(){
//    $('.knob').each(function(){
//        var cur = $(this);
//        // Knob counting script
//        if(cur.val() == 0){
//            $({value: 0}).animate({value: cur.attr("data-end")}, {
//                duration: 2800,
//                easing:'swing',
//                step: function()
//                {
//                    cur.val(Math.ceil(this.value)).trigger('change');
//                    cur.val(cur.val() + '%');
//                }
//            })
//        }
//    });
//
//});
//
//$(function() {
//
//    setTimeout(function(){
//
//        $('.fill-limit').each(function() {
//            var me = $(this);
//            var perc = me.attr("data-limit");
//            var current_perc = 10;
//
//            if(!$(this).hasClass('stop')){
//
//                var progress = setInterval(function() {
//
//                    if (current_perc>=perc) {
//                        clearInterval(progress);
//                    } else {
//                        current_perc +=1;
//                        me.parent().children().children('.filler').css('height', (current_perc)+'%');
//                        me.html(current_perc+'<span>%</span>');
//                    }
//
//                }, 6);
//
//                me.addClass('stop');
//                me.parent().children().children('.filler').addClass('stop');
//
//            }
//
//        });
//
//    }, 0);
//
//});

$(document).ready(function() {
    var hidden = true;
    $('.dd-link').click(function(e) {
        e.preventDefault();
        if (hidden){
            $(this).next('.dd-dropdown').fadeToggle(100, function(){hidden = false;});
        }
    });

    $('html').click(function() {
        if (!hidden) {
            $('.dd-dropdown').fadeOut();
            hidden=true;
        }
    });

    $('.dd-dropdown').click(function(event) {
        event.stopPropagation();
    });
});