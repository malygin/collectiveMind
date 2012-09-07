class Countdown
  constructor: (@target_id = "#timer", @start_time = "30:00") ->

  init: ->
    @reset()
    window.tick = =>
      @tick()
    setInterval(window.tick, 1000)

  reset: ->
    time = @start_time.split(':')
    @minutes = parseInt(time[0])
    @seconds = parseInt(time[1])
    @updateTarget()

  tick: ->
    [seconds, minutes] = [@seconds, @minutes]
    if seconds > 0 or minutes > 0
      if seconds is 0
        @minutes = minutes - 1
        @seconds = 59
      else
        @seconds = seconds - 1
    @updateTarget()

  updateTarget: ->
    seconds = @seconds
    seconds = '0' + seconds if seconds < 10
    $(@target_id).html(@minutes + ":" + seconds)
    
$ ->
  $('ol.comments:first').before('<div id="demo">Click me for demo</div>')
  $('#demo').click ->
    timer = new Countdown('#demo')
    timer.init()
    $('#demo').unbind('click')