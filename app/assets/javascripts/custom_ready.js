
// для открытия попапа просмотра поста
function magnificPopupOpen(tag){
    $.magnificPopup.open({
        items: {
            src: tag, // can be a HTML string, jQuery object, or CSS selector
            type: 'inline',
            midClick: true
        }
    });
};

$(document).ready(function () {

    /* tooltips for all stages */
    $("#tooltip_button_1").click(function() {
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
            type: 'inline'
        });
    };

    /* show hint for question on 1st stage  */
    $('.notice-button').click(function(){
        $('#hint_question_'+$(this).data('question')).removeClass('close-notice');
    });

});