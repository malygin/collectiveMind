function magnificPopupOpen(){
    $.magnificPopup.open({
        items: {
            src: '#popup-innov', // can be a HTML string, jQuery object, or CSS selector
            type: 'inline'
        }
    });
};


/* Your JS codes here */
$(document).ready(function() {

    /* карусель в голосовании

     var owl = $("#owl-vote");
     $("#owl-vote").owlCarousel({
     autoPlay : false,
     stopOnHover : true,
     paginationSpeed : 1000,
     paginationNumbers : true,
     goToFirstSpeed : 2000,
     singleItem : true,
     autoHeight : true,
     transitionStyle:"fade",
     touchDrag : false,
     mouseDrag : false
     });
     $("#owl-arrow-left").click(function(){
     owl.trigger('owl.prev');
     });
     $("#owl-arrow-right").click(function(){
     owl.trigger('owl.next');
     });
     */


    /* чтобы работало две карусели на одной странице */
    var owl1 = $("#owl-vote-1");
    $("#owl-vote-1").owlCarousel({
        autoPlay : false,
        stopOnHover : true,
        paginationSpeed : 1000,
        paginationNumbers : true,
        goToFirstSpeed : 2000,
        singleItem : true,
        autoHeight : true,
        transitionStyle:"fade",
        touchDrag : false,
        mouseDrag : false
    });
    $("#owl-arrow-left-1").click(function(){
        owl1.trigger('owl.prev');
    });
    $("#owl-arrow-right-1").click(function(){
        owl1.trigger('owl.next');
    });

    var owl2 = $("#owl-vote-2");
    $("#owl-vote-2").owlCarousel({
        autoPlay : false,
        stopOnHover : true,
        paginationSpeed : 1000,
        paginationNumbers : true,
        goToFirstSpeed : 2000,
        singleItem : true,
        autoHeight : true,
        transitionStyle:"fade",
        touchDrag : false,
        mouseDrag : false
    });
    $("#owl-arrow-left-2").click(function(){
        owl2.trigger('owl.prev');
    });
    $("#owl-arrow-right-2").click(function(){
        owl2.trigger('owl.next');
    });


    /* замечание модератора */
    $('.admin-notice-displayable').click(function(e){
        e.stopPropagation();
    });


    /* submit на внешней кнопке в попапе с опросом */
    $('#a-submit-int1').click(function(){
        $('#interview-form1').submit();
    });


//    /* подсказка */
    $('.hint .close-button').click(function(){
        $('.hint').addClass("close-notice");
    });
    $('.notice-button').click(function(){
        var questionId;
        questionId = $(this).data('question');
        $('.hint#hint_question_'+questionId).removeClass("close-notice");
    });
//
//
//    /* неверный ответ */
    $('.wrong-answer .close-button').click(function(){
        $('.wrong-answer').addClass("close-notice");
    });
    $('.li_aspect button[data-toggle="tab"]').on('show.bs.tab', function (e) {
        $('.wrong-answer').addClass("close-notice");
    });
//    $('.answer-button').click(function(){
//        $('.wrong-answer').removeClass("close-notice");
//    });


    /* вывод замечания при наведении на знак */
    $('.admin-notice-sign').hover(function(){
        $('.admin-notice-displayable').addClass("show");
    });
    $('.close-admin-button').click(function(){
        $('.admin-notice-displayable').removeClass("show");
    });


    /* ролловер */
    $('.round-button').click(function(){
//        $('.right-rollover-outer').toggleClass("opened", 1000, "easing");
        $('.right-rollover-outer').toggleClass("opened");
        $('.round-button').toggleClass("flipped");
    });
    $('button.colored-stripe').click(function(){
        $('button.colored-stripe').removeClass("selected");
        $(this).toggleClass("selected");
    });



    /* цветные полоски с тегами в нововведении */
    var curId;
    $("a.tag-stripe").hover(function() {
        curId = $(this).parent().attr('id');
        $('#' + curId + " a.tag-stripe").removeClass('active');
        $(this).addClass('active');
    });


    /*$('.post-themes').hover(function() {
     curId = $(this).attr('id');
     $('#' + curId + " a.tag-stripe").hover(function() {
     $('#' + curId + " a.tag-stripe").removeClass('active');
     $(this).addClass('active');
     });
     });*/

    $('.popup-wrapper').css('background', 'rgba(0,0,0,0.3)');

    $('[class*=popup-link]').click(function(e) {

        $('.popup-wrapper').css('display', 'none'); // ???
        /* Предотвращаем действия по умолчанию */
        e.preventDefault();
        e.stopPropagation();

        /* Получаем id (последний номер в имени класса ссылки) */
        var name = $(this).attr('class');
        var id = name[name.length - 1];
        var scrollPos = $(window).scrollTop();

        /* Корректный вывод popup окна, накрытие тенью, предотвращение скроллинга */
        $('#popup-'+id).show();

        /* Убираем баг в Firefox */
        $('html').scrollTop(scrollPos);
    });

    $('#comment-tabs a[href="#name"]').tab('show');

    var prevTabContHeight = 0;
    $('.close-btn').click(function() {
        var scrollPos = $(window).scrollTop();
        /* Скрываем тень и окно, когда пользователь кликнул по X */
        $('[id^=popup-]').hide();
        $("html,body").css("overflow","auto");
        $('html').scrollTop(scrollPos);
        prevTabContHeight = 0;
    });

    /* MagnificPopup */
    $('.open-popup-link').magnificPopup({
        type: 'inline',
        midClick: true
    });


    /* активация и деактивация кнопки "Проголосовать" */
    var voteButton = document.getElementById("vote-button");

    function checkButtonStatement(value, button) {
        if(value){
            if(button.disabled) {
                button.disabled = false;
            }
        } else {
            button.disabled = true;
        }
    };

    /*
     var numSelected = 0;

     $('.drag-block').click(function(){
     ($(this).hasClass("selected")) ? --numSelected : ++numSelected;
     checkButtonStatement(numSelected, voteButton);
     $(this).toggleClass("selected");
     });
     */

    /* для того, чтобы работало несколько на одной странице */
    var voteButton1 = document.getElementById("vote-button1");
    var voteButton2 = document.getElementById("vote-button2");

    var numSelected1 = 0;
    $('.drag1').click(function(){
        ($(this).hasClass("selected")) ? --numSelected1 : ++numSelected1;
        checkButtonStatement(numSelected1, voteButton1);
        $(this).toggleClass("selected");
    });

    var numSelected2 = 0;
    $('.drag2').click(function(){
        ($(this).hasClass("selected")) ? --numSelected2 : ++numSelected2;
        checkButtonStatement(numSelected2, voteButton2);
        $(this).toggleClass("selected");
    });

});


/* Your JS codes here */
//$(document).ready(function() {
//    $('.hint .close-button').click(function(){
//        $('.hint').addClass("close-notice");
//    });
//    $('.notice-button').click(function(){
//        $('.hint').removeClass("close-notice");
//    });
//    $('.wrong-answer .close-button').click(function(){
//        $('.wrong-answer').addClass("close-notice");
//    });
//    $('.answer-button').click(function(){
//        $('.wrong-answer').removeClass("close-notice");
//    });
//    $('.admin-notice-sign').hover(function(){
//        $('.admin-notice-displayable').addClass("show");
//    });
//    $('.close-admin-button').click(function(){
//        $('.admin-notice-displayable').removeClass("show");
//    });
//
//    var curId;
//    var prevTabContHeight = 0;
//
//    $('.round-button').click(function(){
////        $('.right-rollover-outer').toggleClass("opened", 1000, "easing");
//        $('.right-rollover-outer').toggleClass("opened");
//        $('.round-button').toggleClass("flipped");
//    });
//    $('button.colored-stripe').click(function(){
//        $('button.colored-stripe').removeClass("selected");
//        $(this).toggleClass("selected");
//    });
//    $('.post-themes').hover(function() {
//        curId = $(this).attr('id');
//        $('#' + curId + " a.tag-stripe").hover(function() {
//            $('#' + curId + " a.tag-stripe").removeClass('active');
//            $(this).addClass('active');
//        });
//    });
//    $('.popup-wrapper').css('background', 'rgba(0,0,0,0.3)');
//
//    $('[class*=popup-link]').click(function(e) {
//
//        $('.popup-wrapper').css('display', 'none'); // ???
//        /* Предотвращаем действия по умолчанию */
//        e.preventDefault();
//        e.stopPropagation();
//
//        /* Получаем id (последний номер в имени класса ссылки) */
//        var name = $(this).attr('class');
//        var id = name[name.length - 1];
//        var scrollPos = $(window).scrollTop();
//
//        /* Корректный вывод popup окна, накрытие тенью, предотвращение скроллинга */
//        $('#popup-'+id).show();
//
//        /* Убираем баг в Firefox */
//        $('html').scrollTop(scrollPos);
//    });
//
//    $('#comment-tabs a[href="#name"]').tab('show');
//    $('.close-btn').click(function() {
//        var scrollPos = $(window).scrollTop();
//        /* Скрываем тень и окно, когда пользователь кликнул по X */
//        $('[id^=popup-]').hide();
//        $("html,body").css("overflow","auto");
//        $('html').scrollTop(scrollPos);
//        prevTabContHeight = 0;
//    });
//});


//------
/* Your JS codes here */
//$(document).ready(function() {
//    $('.hint .close-button').click(function(){
//        $('.hint').addClass("close-notice");
//    });
//    $('.notice-button').click(function(){
//        $('.hint').removeClass("close-notice");
//    });
//    $('.wrong-answer .close-button').click(function(){
//        $('.wrong-answer').addClass("close-notice");
//    });
//    $('.answer-button').click(function(){
//        $('.wrong-answer').removeClass("close-notice");
//    });
//    $('.admin-notice-sign').hover(function(){
//        $('.admin-notice-displayable').addClass("show");
//    });
//    $('.close-admin-button').click(function(){
//        $('.admin-notice-displayable').removeClass("show");
//    });
//
//    var curId;
//    var prevTabContHeight = 0;
//
//    $('.round-button').click(function(){
//        $('.right-rollover-outer').toggleClass("opened", 1000, "easing");
//        $('.round-button').toggleClass("flipped");
//    });
//    $('button.colored-stripe').click(function(){
//        $('button.colored-stripe').removeClass("selected");
//        $(this).toggleClass("selected");
//    });
//    $('.post-themes').hover(function() {
//        curId = $(this).attr('id');
//        $('#' + curId + " a.tag-stripe").hover(function() {
//            $('#' + curId + " a.tag-stripe").removeClass('active');
//            $(this).addClass('active');
//        });
//    });
//    $('.popup-wrapper').css('background', 'rgba(0,0,0,0.3)');
//
//    $('[class*=popup-link]').click(function(e) {
//
//        $('.popup-wrapper').css('display', 'none');
//        /* Предотвращаем действия по умолчанию */
//        e.preventDefault();
//        e.stopPropagation();
//
//        /* Получаем id (последний номер в имени класса ссылки) */
//        var name = $(this).attr('class');
//        var id = name[name.length - 1];
//        var scrollPos = $(window).scrollTop();
//
//        /* Корректный вывод popup окна, накрытие тенью, предотвращение скроллинга */
//        $('#popup-'+id).show();
//
//        /* Убираем баг в Firefox */
//        $('html').scrollTop(scrollPos);
//    });
//
//    $('#comment-tabs a[href="#name"]').tab('show');
//    $('.close-btn').click(function() {
//        var scrollPos = $(window).scrollTop();
//        /* Скрываем тень и окно, когда пользователь кликнул по X */
//        $('[id^=popup-]').hide();
//        $("html,body").css("overflow","auto");
//        $('html').scrollTop(scrollPos);
//        prevTabContHeight = 0;
//    });
//});