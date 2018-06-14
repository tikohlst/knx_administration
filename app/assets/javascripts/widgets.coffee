# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # Laden einer neuen Regel beim Auswählen des Links "Neue Öffnungszeiten"
  if window.location.href.indexOf('edit') > -1 or window.location.href.indexOf('new') > -1
    counter = document.getElementById('data').innerHTML

    if counter < 1
      counter = 1
    else if counter >= 5
# Wenn beim Laden der Seite schon 5 Regeln existieren, Link nicht anzeigen
      $('#new_widget_rules').hide()

    $('#new_widget_rules').on 'click', (event) ->
      counter = parseInt counter, 10
      switch counter
        when 1
          $('#div_id').append($('<div></div>').load('rules #second'))
          document.getElementById('data').innerHTML = 2
        when 2
          $('#div_id').append $('<div></div>').load('rules #third')
          document.getElementById('data').innerHTML = 3
        when 3
          $('#div_id').append $('<div></div>').load('rules #fourth')
          document.getElementById('data').innerHTML = 4
        when 4
          $('#div_id').append $('<div></div>').load('rules #fifth')
          document.getElementById('data').innerHTML = 5
      counter++
      # Es dürfen nicht mehr als fünf Regeln erstellt werden
      if counter >= 5
        $('#new_martial_art_opening_times').hide()
      return
    return