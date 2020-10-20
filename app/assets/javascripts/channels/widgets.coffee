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
        # Update textField, if it is not a status of a window or the rain alarm
        if (data.dpt != '1.002' && data.dpt != '1.009')
          switch data.dpt
            when '9.001'
              # Show the temperature as a float with only one digit after comma
              $('#widget_active_' + data.id).text(parseFloat(data.status).toFixed(1))
            when '9.004', '9.005'
              # Show brightness and wind speed as integers
              $('#widget_active_' + data.id).text(Math.round(data.status))
            else
              $('#widget_active_' + data.id).text(data.status)
        # Update the graphical representation
        switch data.dpt
          when '1.002'
            # Update rain alarm status
            if (data.status == 'on' || data.status == 1)
              $('#widget_active_' + data.id + ' > .red-note').addClass('d-none')
              $('#widget_active_' + data.id + ' > .green-note').removeClass('d-none')
            else
              $('#widget_active_' + data.id + ' > .green-note').addClass('d-none')
              $('#widget_active_' + data.id + ' > .red-note').removeClass('d-none')
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
            if /Ist-Temperatur - Heizungsaktor/.test data.desc
              $('#canvas-temperature-radiators' + data.id).attr('data-value', data.status)
            else
              switch data.desc
                when 'Temperatur'
                  $('#canvas-temperature').attr('data-value', data.status)
                when 'Temperatur rechts'
                  $('#canvas-temperature-right').attr('data-value', data.status)
                when 'Temperatur links'
                  $('#canvas-temperature-left').attr('data-value', data.status)
          when '9.004'
            # Update brightness
            $('#canvas-brightness').attr('data-value', Math.log10(parseFloat(data.status)))
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
