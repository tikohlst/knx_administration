App.widgets = App.cable.subscriptions.create "WidgetsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if (data.active == true)
      $('#widget' + data.id).bootstrapToggle('on')
    else
      $('#widget' + data.id).bootstrapToggle('off')