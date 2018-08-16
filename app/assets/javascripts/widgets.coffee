# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # Open first entry in every tab
  array = $('#widgets_card > .card-body > .tab-content > .tab-pane.fade > .accordion')
    .map(->@id).get()
  $.each array, (index, value) ->
    # Turn first triangle
    $('#' + value + ' > div > div > .row > .col > .mb-0 > button > span').first()
      .removeClass('glyphicon-triangle-right').addClass 'glyphicon-triangle-bottom'
    # Show first content
    $('#' + value + ' > div > .collapse').first().addClass 'show'
    return

  ###############################################################################
  ### All following functions need on-click-event for working after rendering ###
  ###############################################################################

  # Scroll to the widgets after clicking on sort-type or widgets-group in mobile display
  $(document).on 'click', '#widgets_card > .card-header > .nav > li > a,
    .justify-content-between > .col-md-4 > .navbar-brand > .btn-group ', ->
    if ($('#nav-tab-responsive').css('display') == 'block')
      window.scrollTo(0, document.getElementById('nav-tabContent').offsetTop)
    return

  # Submit the form of the clicked widget
  $(document).on 'click', '.edit_widget', ->
    Rails.fire(document.querySelector('#' + $(this).attr('id')), 'submit')
    return

  # Make sure the triangles turn
  $(document).on 'click', '.accordion > div > div > .row > .col > .mb-0 > .btn', ->
    if ($(this).children('span').hasClass('glyphicon-triangle-bottom'))
      $(this).children('span').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
    else
      accordion_id = $(this).parent().parent().parent().parent().parent().parent().attr('id')
      $('#' + accordion_id + ' .glyphicon-triangle-bottom').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right')
      $(this).children('span').toggleClass('glyphicon-triangle-right glyphicon-triangle-bottom')

  # Hash for saving intervals with id of the progress bar as key
  intervals = {}

  # Start opening the shutter or blind
  $(document).on 'click', '.card-body > div > .float-left > .btn-group > .btn:first-child', ->
    openButton = $(this)
    self_id = openButton.children(":first").attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
      # Change the color of the opening and closing "span" to black
      openButton.parent().parent().parent().children('.float-right').children('.btn-group')
        .children('button:last').children('span').css('color', 'black')
      openButton.children('span').css('color', 'black')
    else
      # If the progress bar is inactive, start progress.
      # The width of pixel in percent must be calculated, since this is returned later in percent
      progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
      progressbar_parent = $('#progressbar-' + self_id).parent().width()
      percent = (progressbar / progressbar_parent) * 100
      # Changes the color of the of the opening "span" white and the closing "span" black
      openButton.parent().parent().parent().children('.float-right').children('.btn-group')
        .children('button:last').children('span').css('color', 'black')
      openButton.children('span').css('color', 'white')
      # Start interval for opening the shutter or blind
      intervals[self_id] = setInterval () ->
        frame()
      , 250
      frame = ->
        if percent <= 0
          # If the progress bar reaches 0%, stop progress
          clearInterval intervals[self_id]
          intervals[self_id] = null
          # Change the color of the opening "span" to black
          openButton.children('span').css('color', 'black')
        else
          # Subtract one percent and change the width of the progress bar in the CSS
          percent--
          $('#progressbar-' + self_id).css("width", percent + '%')
    return

  # One step opening the shutter or blind
  $(document).on 'click', '.card-body > div > .float-left > .btn-group > .btn:last-child', ->
    oneStepOpenButton = $(this)
    self_id = oneStepOpenButton.children(":first").attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
      # Change the color of the opening and closing "span" to black
      oneStepOpenButton.parent().parent().parent().children('.float-right').children('.btn-group')
        .children('button:last').children('span').css('color', 'black')
      oneStepOpenButton.parent().children('button:first').children('span').css('color', 'black')
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

  # One step closing the shutter or blind
  $(document).on 'click', '.card-body > div > .float-right > .btn-group > .btn:first-child', ->
    oneStepCloseButton = $(this)
    self_id = oneStepCloseButton.children(":first").attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
      # Change the color of the opening and closing "span" to black
      oneStepCloseButton.parent().parent().parent().children('.float-left').children('.btn-group')
        .children('button:first').children('span').css('color', 'black')
      oneStepCloseButton.parent().children('button:last').children('span').css('color', 'black')
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

  # Start closing the shutter or blind
  $(document).on 'click', '.card-body > div > .float-right > .btn-group > .btn:last-child', ->
    closeButton = $(this)
    self_id = closeButton.children(":last").attr('id')
    if intervals[self_id]
      # If the progress bar is active, stop progress
      clearInterval intervals[self_id]
      intervals[self_id] = null
      # Change the color of the opening and closing "span" to black
      closeButton.parent().parent().parent().children('.float-left').children('.btn-group')
        .children('button:first').children('span').css('color', 'black')
      closeButton.children('span').css('color', 'black')
    else
      # If the progress bar is inactive, start progress.
      # The width of pixel in percent must be calculated, since this is returned later in percent
      progressbar = parseInt($('#progressbar-' + self_id).css('width').replace(/px/g,''))
      progressbar_parent = $('#progressbar-' + self_id).parent().width()
      percent = (progressbar / progressbar_parent) * 100
      # Changes the color of the of the closing "span" white and the opening "span" black
      closeButton.parent().parent().parent().children('.float-left').children('.btn-group')
        .children('button:first').children('span').css('color', 'black')
      closeButton.children('span').css('color', 'white')
      # Start interval for closing the shutter or blind
      intervals[self_id] = setInterval () ->
        frame()
      , 250
      frame = ->
        if percent >= 100
          # If the progress bar reaches 100%, stop progress
          clearInterval intervals[self_id]
          intervals[self_id] = null
          # Change the color of the closing "span" to black
          closeButton.children('span').css('color', 'black')
        else
          # Add one percent and change the width of the progress bar in the CSS
          percent++
          $('#progressbar-' + self_id).css("width", percent + '%')
    return

  $(document).on 'click', '.submit_lightings', ->
    console.log(('#' + $(this).attr('id')))
    return
