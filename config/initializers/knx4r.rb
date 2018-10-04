if ENV['KNX_CONNECTION'] == "1"
  ###################################################################################
  # Initialize KNXnetIP connection                                                  #
  ###################################################################################
  require 'rexml/document'
  include KNX

  @gw = KNXnetIP::Gateway.new( clientHostIP: ENV['HOST_IP'] )
  emi_server = CEMI_Server.new
  logger = KNX_Logger.new(desc: 'L_Data logger')
  emi_server.attach_logger( logger )
  @gw.attach( emi_server )
  @gw.connect( @gw.find || {} )
  @prj = KNXproject.load(Rails.root.join('config', 'knx_config.xml').to_s)
  @prj.emi_server = emi_server
  # Update devices and add devices to emi_server
  @prj.attach_devices
  devs = @prj.devices
  $locations = @prj.locations

  ###################################################################################
  # Create Roles, Users, OrgUnits and Accesses in the database                      #
  ###################################################################################
  if ENV['SEEDS'] == "1"
    connection = ActiveRecord::Base.connection()
    connection.execute("TRUNCATE TABLE roles;")
    connection.execute("TRUNCATE TABLE users;")
    connection.execute("TRUNCATE TABLE users_roles;")
    connection.execute("TRUNCATE TABLE org_units;")
    connection.execute("TRUNCATE TABLE accesses;")

    # User username:string password:string password_confirmation:string role:int language:string
    users_list = [
        [ "admin", "123456", "123456", :admin, "de" ],
        [ "tikoh", "123456", "123456", :editor, "de" ],
        [ "user1", "123456", "123456", :observer, "en" ],
        [ "user2", "123456", "123456", :editor, "de" ],
    ]

    users_list.each do |username, password, password_confirmation, role, language|
      user = User.create!( username: username, password: password, password_confirmation: password_confirmation, language: language )
      # Add role for rolify
      user.add_role role
    end

    # OrgUnit name:string
    @prj.org_units.each do |key, value|
      OrgUnit.create!( name: value, key: key )
    end

    # Access user_id:int org_unit_id:int
    number_of_org_units = OrgUnit.count
    accesses_list = []
    (1..4).each do |user_id|
      (1..number_of_org_units).each do |org_unit_id|
        accesses_list << [user_id, org_unit_id]
      end
    end
    
    accesses_list.each do |user_id, org_unit_id|
      Access.create!( user_id: user_id, org_unit_id: org_unit_id )
    end
  end

  ###################################################################################
  # Create a widget for each device                                                 #
  ###################################################################################

  devs.sort do |a,b|
    rc = @prj.org_units[a.ouref] <=> @prj.org_units[b.ouref]
    rc==0 ? a.desc <=> b.desc : rc
  end.each do |dev|
    case dev
    when KNX_Driver, KNX_DimmerDriver
      case pdev = dev.parent
      when KNX_Blind
        pdev.driver.update_from_bus
        @progress_bar = Widget::ProgressBar.new(pdev)
        pdev.slider.attach( @progress_bar )
      when KNX_Dimmer
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
      unless dev.parent.is_a? KNX_Dimmer
        # Update to the actual status of the KNX_Switch
        dev.update_from_bus
        @button = Widget::Button.new(dev)
        dev.attach( @button )
      end
    when KNX_Toggle, KNX_Rocker, KNX_Date, KNX_Time, KNX_Setter, KNX_Interface,
        KNX_Stepper, Slider
      # Ignore
    else
      puts "Class not yet supported: #{dev.class}"
    end
  end
end