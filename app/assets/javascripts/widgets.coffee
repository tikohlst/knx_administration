# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # All functions need on-click-event for working after rendering

  # Submit the form of the clicked widget
  $(document).on 'click', '.edit_widget', ->
    Rails.fire(document.querySelector('#' + $(this).attr('id')), 'submit')
    return

  # Make sure the triangles turn
  $(document).on 'click', '.accordion > .card > .card-header > .mb-0 > .btn', ->
    if ($(this).children('span').hasClass('glyphicon-triangle-bottom'))
      $(this).children('span').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
    else
      accordion_id = $(this).parent().parent().parent().parent().attr('id')
      $('#' + accordion_id + ' .glyphicon-triangle-bottom').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
      $(this).children('span').toggleClass('glyphicon-triangle-right glyphicon-triangle-bottom')


  $(document).on 'click', '.submit_lightings', ->
    console.log(('#' + $(this).attr('id')))
    return
