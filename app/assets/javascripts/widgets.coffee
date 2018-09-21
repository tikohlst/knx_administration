# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # Open the first entry in every tab
  array = $('#widgets_card > .card-body > .tab-content > .tab-pane.fade > .accordion')
    .map(->@id).get()
  $.each array, (index, value) ->
    # Turn first triangle
    $('#' + value + ' > div > .mb-2 > .row > .col > .mb-0 > button > span').first()
      .removeClass('glyphicon-triangle-right').addClass('glyphicon-triangle-bottom')
    # Show first content
    $('#' + value + ' > div > .collapse').first().addClass('show')
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
    # Only submit if the user isn't just a observer
    if $(document.body).data('observer') != true
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
