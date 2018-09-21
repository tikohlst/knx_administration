App.widgets = App.cable.subscriptions.create "WidgetsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.type
      when "button"
        if (data.status == 1)
          if $(document.body).data('observer') != true
            $('#widget_active_' + data.id).bootstrapToggle('on')
          else
            # The button must be enabled in order to be able to switch it on/off
            $('#widget_active_' + data.id).bootstrapToggle('enable')
            $('#widget_active_' + data.id).bootstrapToggle('on')
            $('#widget_active_' + data.id).bootstrapToggle('disable')
        else
          if $(document.body).data('observer') != true
            $('#widget_active_' + data.id).bootstrapToggle('off')
          else
            # The button must be enabled in order to be able to switch it on/off
            $('#widget_active_' + data.id).bootstrapToggle('enable')
            $('#widget_active_' + data.id).bootstrapToggle('off')
            $('#widget_active_' + data.id).bootstrapToggle('disable')
      when "progressBar"
        $('#progressbar-' + data.id).css("width", data.status["position"] + "%")
      when "slider"
        $('#widget_active_' + data.id).val(data.status)
      when "textField"
        if (data.dpt == '1.009')
          # Change open and closed status for windows and doors
          if (data.status == 1)
            $('#widget_active_' + data.id + '> .red-note').addClass('d-none')
            $('#widget_active_' + data.id + '> .green-note').removeClass('d-none')
          else
            $('#widget_active_' + data.id + '> .green-note').addClass('d-none')
            $('#widget_active_' + data.id + '> .red-note').removeClass('d-none')
        else
          # Change textField
          $('#widget_active_' + data.id).text(data.status)
