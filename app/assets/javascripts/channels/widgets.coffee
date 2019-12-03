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
        if (data.dpt != '1.009')
          # Change textField, if it is not a status of a window
          $('#widget_active_' + data.id).text(data.status)
        switch data.dpt
          when '1.009'
            # Update open and closed status for windows and doors
            if (data.status == 'off')
              $('#widget_active_' + data.id + ' > .red-note').addClass('d-none')
              $('#widget_active_' + data.id + ' > .green-note').removeClass('d-none')
            else
              $('#widget_active_' + data.id + ' > .green-note').addClass('d-none')
              $('#widget_active_' + data.id + ' > .red-note').removeClass('d-none')
          when '9.001'
            # Update temperature
            switch data.desc
              when 'Temperatur'
                $('#canvas-temperature').attr('data-value', data.status)
              when 'Temperatur 1'
                $('#canvas-temperature1').attr('data-value', data.status)
              when 'Temperatur 2'
                $('#canvas-temperature2').attr('data-value', data.status)
          when '9.004'
            # Update brightness
            $('#canvas-brightness').attr('data-value', data.status)
          when '9.005'
            # Update wind speed
            $('#canvas-wind-speed').attr('data-value', data.status)
          when '9.029'
            if (data.desc == "Azimut Sonne")
              # Update azimut
              $('#canvas-azimut').attr('data-value', data.status)
            else
              # Update elevation
              $('#canvas-elevation').attr('data-value', data.status)
