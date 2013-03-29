# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
updateCountdownAttributes = (toRemove, toAdd = null) ->
  for attr in toRemove
    $(".remaining, .countdown").removeClass attr
  if toAdd
    $(".remaining, .countdown").addClass toAdd
    if toAdd is "overlimit"
      $("input.btn.btn-large.btn-primary").attr("disabled", "true")
    else
      $("input.btn.btn-large.btn-primary").removeAttr("disabled")

updateCountdown = ->
  remaining = 400 - $("#frustration_what").val().length - $("#frustration_wherin").val().length - $("#frustration_when").val().length
  toRemove = ["nearlimit", "almostlimit", "overlimit"]
  if remaining > 19
    updateCountdownAttributes(toRemove)
  if remaining < 20
    toAdd = (toRemove.filter (attr) -> attr is "nearlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  if remaining < 11
    toAdd = (toRemove.filter (attr) -> attr is "almostlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  if remaining < 0
    toAdd = (toRemove.filter (attr) -> attr is "overlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  $(".countdown").text remaining

$(document).ready ->
  $(".countdown").text 400
  $("#frustration_what").change updateCountdown
  $("#frustration_what").keyup updateCountdown
  $("#frustration_what").keydown updateCountdown
  $("#frustration_what").keypress updateCountdown  

  $("#frustration_wherin").change updateCountdown
  $("#frustration_wherin").keyup updateCountdown
  $("#frustration_wherin").keydown updateCountdown
  $("#frustration_wherin").keypress updateCountdown

  $("#frustration_when").change updateCountdown
  $("#frustration_when").keyup updateCountdown
  $("#frustration_when").keydown updateCountdown
  $("#frustration_when").keypress updateCountdown

