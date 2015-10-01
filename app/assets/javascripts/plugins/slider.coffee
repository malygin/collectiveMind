### слайдер для аспектов для 1 стадии ###
@slider_scripts = ->
  offset = 30

  this.count_inner = ->
    sliders_sum = 0
    $('.slider-inner li').each ->
      sliders_sum += $(this).innerWidth()
    sliders_sum

  this.click_item = ->
    if !$(this).hasClass('slide')
      $('.slider-inner li').removeClass 'slide'
      $(this).addClass 'slide'
      left_pos = count_pos() + 1
      right_pos = left_pos + $(this).innerWidth()
      if left_pos < offset
        $('.slider-left').click()
      else if right_pos < offset + outer_w
      else
        $('.slider-right').click()

  this.slide_inner = ->
    dir = $(this).data('type')
    offf = offset
    sum_i = 0
    m = 0
    right_point = offf + outer_w
    $('.slider-inner li').each ->
      me = $(this)
      sum_i += me.innerWidth()
      if dir == 'left' and offf
        if sum_i >= offf
          m = me.innerWidth() - (sum_i - offf)
          return false
      else if dir == 'right'
        if sum_i > right_point
          m = sum_i - right_point
          return false
    if m
      if dir == 'left'
        offf -= m
      else if dir == 'right'
        offf += m
      anim = []
      anim['margin-left'] = -offf + 'px'
      $('.slider-inner').animate anim, 500
      offset = offf

  this.count_pos = ->
    sum_i = 0
    $('.slider-inner li').each ->
      me = $(this)
      if me.hasClass('slide')
        return false
      else
        sum_i += me.innerWidth()
    sum_i

  inner_w = count_inner() + 100
  $('.slider-inner').css 'width', inner_w + 'px'
  outer_w = $('.slider-outer').innerWidth()

  ### events ###
  $('.slider-inner').on('click', 'li', this.click_item)
  $('.slider-nav').on('click', '.slider-btn', this.slide_inner)
