/* слайдер для аспектов для 1 стадии */
var offset = 300;
/* set inner width */
var inner = $('.slider-inner');
var inner_w = count_inner() + 100;
inner.css('width', inner_w + 'px');

/* count outer width */
var outer = $('.slider-outer');
var outer_w = outer.innerWidth();

/* events */
$('.slider-item').click(function () {
    click_item($(this));
});
$('.slider-right').click(function () {
    slide_inner(outer_w, offset, 'right');
});
$('.slider-left').click(function () {
    slide_inner(outer_w, offset, 'left');
});

function count_inner() {
    var sliders_sum = 0;
    $('.slider-item').each(function () {
        sliders_sum += $(this).innerWidth();
    });
    return sliders_sum;
};

function slide_inner(out, off, dir) {
    var sum_i = 0;
    var m = 0;
    var right_point = off + out;

    $('.slider-item').each(function () {
        var me = $(this);
        sum_i += me.innerWidth();
        if (dir == 'left' && off) {
            if (sum_i >= off) {
                m = me.innerWidth() - (sum_i - off);
                return false;
            }
        } else if (dir == 'right') {
            if (sum_i > right_point) {
                m = sum_i - right_point;
                return false;
            }
        }
    });

    if (m) {
        if (dir == 'left') {
            off -= m;
        } else if (dir == 'right') {
            off += m;
        }
        var anim = [];
        anim['margin-left'] = -off + 'px';
        inner.animate(anim, 500);

        offset = off;
    }
};

function click_item(item) {
    if (!(item.hasClass('active'))) {
        $('.slider-item').removeClass('active');
        item.addClass('active');
        var left_pos = count_pos() + 1;
        var right_pos = left_pos + item.innerWidth();
        if (left_pos < offset) {
            slide_inner(outer_w, offset, "left");
        } else if (right_pos < (offset + outer_w)) {

        } else {
            slide_inner(outer_w, offset, "right");
        }
        ;
    }
    ;
};

function count_pos() {
    var sum_i = 0;
    var m = 0;
    $('.slider-item').each(function () {
        var me = $(this);
        if (me.hasClass('active')) {
            return false;
        } else {
            sum_i += me.innerWidth();
        }
    });
    return sum_i;
}
