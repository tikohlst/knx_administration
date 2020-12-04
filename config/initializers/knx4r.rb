if ENV['KNX_CONNECTION'] == "1"
  ###################################################################################
  # Initialize KNXnetIP connection                                                  #
  ###################################################################################
  require 'rexml/document'
  include KNX4R

  gw = KNXnetIP::Gateway.new( clientHostIP: ENV['HOST_IP'] )
  $emi_server = CEMI_Client.new
  logger = KNX4R::Logger.new(desc: 'L_Data logger')
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
    when Driver, DimmerDriver
      case pdev = dev.parent
      when Blind
        pdev.driver.update_from_bus
        @progress_bar = Widget::ProgressBar.new(pdev)
        pdev.slider.attach( @progress_bar )
      when Dimmer, Setter
        pdev.driver.update_from_bus
        @slider = Widget::Slider.new(pdev)
        pdev.slider.attach( @slider )
      else
        raise "Unknown parent: #{pdev.class}"
      end
    when Value, Binary
      # Update to the actual status of the KNX_Value
      dev.update_from_bus
      @text_field = Widget::TextField.new(dev)
      dev.attach( @text_field )
    when Switch
      # Don't show the switch for the dimmers
      unless [Dimmer, Setter].member? dev.parent.class
        # Update to the actual status of the KNX_Switch
        dev.update_from_bus
        @button = Widget::Button.new(dev)
        dev.attach( @button )
      end
    when Toggle, Rocker, Date, Time, Interface,
        Stepper, Slider
      # Ignore
    else
      puts "Class not yet supported: #{dev.class}"
    end
  end
end
