# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

# Edit the user after clicking on line in /users/
  $('tr[data-link]').on 'click', (event) ->
    if $('#table_users').length > 0
      window.location.href="/users/" + $(this).attr('data-link') + "/edit"
    return