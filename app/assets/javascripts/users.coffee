# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  ###############################################################################
  ### All following functions need on-click-event for working after rendering ###
  ###############################################################################

  # Open the users edit form after clicking on a line in "users/"
  $(document).on 'click', 'tr[data-link]', ->
    if $('#table_users').length > 0
      window.location.href = "users/" + $(this).attr('data-link') + "/edit"
    return
