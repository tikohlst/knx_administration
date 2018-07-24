# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # Submit the form of the clicked widget
  $(".edit_widget").click ->
    $('#' + $(this).attr('id')).submit()
    return
