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
  $(document).on 'click', '.accordion > div > div > .mb-0 > .btn', ->
    if ($(this).children('span').hasClass('glyphicon-triangle-bottom'))
      $(this).children('span').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
    else
      accordion_id = $(this).parent().parent().parent().parent().attr('id')
      $('#' + accordion_id + ' .glyphicon-triangle-bottom').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
      $(this).children('span').toggleClass('glyphicon-triangle-right glyphicon-triangle-bottom')

  # Hash for saving intervals with id of the progress bar as key
  intervals = {}

  $(document).on 'click', '.glyphicon-step-forward', ->
    self_id = $(this).attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
    else
      # If the progress bar is inactive, start progress. Here, the width of pixel in percent
      # must be calculated, since this is returned later in percent
      progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
      progressbar_parent = $('#progressbar-' + self_id).parent().width()
      percent = (progressbar / progressbar_parent) * 100
      intervals[self_id] = setInterval () ->
        frame()
      , 250
      frame = ->
        if percent >= 100
          # If the progress bar reaches 100%, stop progress
          clearInterval intervals[self_id]
          intervals[self_id] = null
        else
          # Add one percent and change the width of the progress bar in the CSS
          percent++
          $('#progressbar-' + self_id).css("width", percent + '%')
    return

  $(document).on 'click', '.glyphicon-forward', ->
    self_id = $(this).attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
    # Here, the width of pixel in percent must be calculated, since this is returned later in percent
    progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
    progressbar_parent = $('#progressbar-' + self_id).parent().width()
    percent = (progressbar / progressbar_parent) * 100
    if percent < 100
      # If the progress bar hasn't reached hundred percent, subtract one percent and change the
      # width of the progress bar in the CSS
      percent++
      $('#progressbar-' + self_id).css("width", percent + '%')
    return

  $(document).on 'click', '.glyphicon-step-backward', ->
    self_id = $(this).attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
    else
      # If the progress bar is inactive, start progress. Here, the width of pixel in percent
      # must be calculated, since this is returned later in percent
      progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
      progressbar_parent = $('#progressbar-' + self_id).parent().width()
      percent = (progressbar / progressbar_parent) * 100
      intervals[self_id] = setInterval () ->
        frame()
      , 250
      frame = ->
        if percent <= 0
          # If the progress bar reaches 0%, stop progress
          clearInterval intervals[self_id]
          intervals[self_id] = null
        else
          # Subtract one percent and change the width of the progress bar in the CSS
          percent--
          $('#progressbar-' + self_id).css("width", percent + '%')
    return

  $(document).on 'click', '.glyphicon-backward', ->
    self_id = $(this).attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
    # Here, the width of pixel in percent must be calculated, since this is returned later in percent
    progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
    progressbar_parent = $('#progressbar-' + self_id).parent().width()
    percent = (progressbar / progressbar_parent) * 100
    if percent > 0
      # If the progress bar hasn't reached zero percent, subtract one percent and change the
      # width of the progress bar in the CSS
      percent--
      $('#progressbar-' + self_id).css("width", percent + '%')
    return


  $(document).on 'click', '.submit_lightings', ->
    console.log(('#' + $(this).attr('id')))
    return
