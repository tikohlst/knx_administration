if ENV['KNX_CONNECTION'] == "1"
  ###################################################################################
  # Initialize KNXnetIP connection                                                  #
  ###################################################################################
  require 'rexml/document'
  include KNX

  gw = KNXnetIP::Gateway.new( clientHostIP: ENV['HOST_IP'] )
  $emi_server = CEMI_Server.new
  logger = KNX_Logger.new(desc: 'L_Data logger')
  $emi_server.attach_logger( logger )
  gw.attach( $emi_server )
  gw.connect( gw.find || {} )
  prj = KNXproject.load(Rails.root.join('config', 'knx_config.xml').to_s)
  prj.emi_server = $emi_server
  $locations = prj.locations

  ###################################################################################
  # Create a widget for each device                                                 #
  ###################################################################################

  # Update devices and add devices to emi_server
  prj.attach_devices

  prj.devices.sort do |a,b|
    rc = prj.org_units[a.ouref] <=> prj.org_units[b.ouref]
    rc==0 ? a.desc <=> b.desc : rc
  end.each do |dev|
    case dev
    when KNX_Driver, KNX_DimmerDriver
      case pdev = dev.parent
      when KNX_Blind
        pdev.driver.update_from_bus
        @progress_bar = Widget::ProgressBar.new(pdev)
        pdev.slider.attach( @progress_bar )
      when KNX_Dimmer, KNX_Setter
        pdev.driver.update_from_bus
        @slider = Widget::Slider.new(pdev)
        pdev.slider.attach( @slider )
      else
        raise "Unknown parent: #{pdev.class}"
      end
    when KNX_Value, KNX_Binary
      # Update to the actual status of the KNX_Value
      dev.update_from_bus
      @text_field = Widget::TextField.new(dev)
      dev.attach( @text_field )
    when KNX_Switch
      # Don't show the switch for the dimmers
      unless [KNX_Dimmer, KNX_Setter].member? dev.parent.class
        # Update to the actual status of the KNX_Switch
        dev.update_from_bus
        @button = Widget::Button.new(dev)
        dev.attach( @button )
      end
    when KNX_Toggle, KNX_Rocker, KNX_Date, KNX_Time, KNX_Interface,
        KNX_Stepper, Slider
      # Ignore
    else
      puts "Class not yet supported: #{dev.class}"
    end
  end
end
