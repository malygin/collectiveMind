/* Your JS codes here */
$(document).ready(function() {
    $('.hint .close-button').click(function(){
        $('.hint').addClass("close-notice");
    });
    $('.notice-button').click(function(){
        $('.hint').removeClass("close-notice");
    });
    $('.wrong-answer .close-button').click(function(){
        $('.wrong-answer').addClass("close-notice");
    });
    $('.answer-button').click(function(){
        $('.wrong-answer').removeClass("close-notice");
    });
    $('.admin-notice-sign').hover(function(){
        $('.admin-notice-displayable').addClass("show");
    });
    $('.close-admin-button').click(function(){
        $('.admin-notice-displayable').removeClass("show");
    });

    var curId;
    var prevTabContHeight = 0;

    $('.round-button').click(function(){
//        $('.right-rollover-outer').toggleClass("opened", 1000, "easing");
        $('.right-rollover-outer').toggleClass("opened");
        $('.round-button').toggleClass("flipped");
    });
    $('button.colored-stripe').click(function(){
        $('button.colored-stripe').removeClass("selected");
        $(this).toggleClass("selected");
    });
    $('.post-themes').hover(function() {
        curId = $(this).attr('id');
        $('#' + curId + " a.tag-stripe").hover(function() {
            $('#' + curId + " a.tag-stripe").removeClass('active');
            $(this).addClass('active');
        });
    });
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
    $('.close-btn').click(function() {
        var scrollPos = $(window).scrollTop();
        /* Скрываем тень и окно, когда пользователь кликнул по X */
        $('[id^=popup-]').hide();
        $("html,body").css("overflow","auto");
        $('html').scrollTop(scrollPos);
        prevTabContHeight = 0;
    });
});

//------
/* Your JS codes here */
$(document).ready(function() {
    $('.hint .close-button').click(function(){
        $('.hint').addClass("close-notice");
    });
    $('.notice-button').click(function(){
        $('.hint').removeClass("close-notice");
    });
    $('.wrong-answer .close-button').click(function(){
        $('.wrong-answer').addClass("close-notice");
    });
    $('.answer-button').click(function(){
        $('.wrong-answer').removeClass("close-notice");
    });
    $('.admin-notice-sign').hover(function(){
        $('.admin-notice-displayable').addClass("show");
    });
    $('.close-admin-button').click(function(){
        $('.admin-notice-displayable').removeClass("show");
    });

    var curId;
    var prevTabContHeight = 0;

    $('.round-button').click(function(){
        $('.right-rollover-outer').toggleClass("opened", 1000, "easing");
        $('.round-button').toggleClass("flipped");
    });
    $('button.colored-stripe').click(function(){
        $('button.colored-stripe').removeClass("selected");
        $(this).toggleClass("selected");
    });
    $('.post-themes').hover(function() {
        curId = $(this).attr('id');
        $('#' + curId + " a.tag-stripe").hover(function() {
            $('#' + curId + " a.tag-stripe").removeClass('active');
            $(this).addClass('active');
        });
    });
    $('.popup-wrapper').css('background', 'rgba(0,0,0,0.3)');

    $('[class*=popup-link]').click(function(e) {

        $('.popup-wrapper').css('display', 'none');
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
    $('.close-btn').click(function() {
        var scrollPos = $(window).scrollTop();
        /* Скрываем тень и окно, когда пользователь кликнул по X */
        $('[id^=popup-]').hide();
        $("html,body").css("overflow","auto");
        $('html').scrollTop(scrollPos);
        prevTabContHeight = 0;
    });
});