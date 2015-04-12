$(document).ready(function () {

    /* tooltips for all stages */
    $("#tooltip_button_1").click(function() {
        $(".tooltip1").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close')
    });
    $("#tooltip_button_2").click(function() {
        $(".tooltip2").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close')
    });
    $("#tooltip_button_3").click(function() {
        $(".tooltip3").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close')
    });
    $("#tooltip_button_4").click(function() {
        $(".tooltip4").tooltip('toggle');
        $(this).toggleClass('btn-tooltip btn-tooltip-close')
    });
    $("#tooltip_button_5").click(function() {
        $(".tooltip5").tooltip('toggle');
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
    $.magnificPopup.open({
        items: {
            src: '.popup-vote'
        },
        type: 'inline'
    });



});