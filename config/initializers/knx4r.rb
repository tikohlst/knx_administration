###################################################################################
# Initialize KNXnetIP connection                                                  #
###################################################################################
require 'rexml/document'
include KNX

@gw = KNXnetIP::Gateway.new( clientHostIP: "10.200.73.20" || ENV['HOST_IP'])
emi_server = CEMI_Server.new
logger = KNX_Logger.new(desc: 'L_Data logger')
emi_server.attach_logger( logger )
@gw.attach( emi_server )
@gw.connect( @gw.find || {} )

#@prj = KNXproject.load("/Users/Tim/Documents/Studium (Bachelor)/8.Semester/"\
#                       "Thesis (Werntges + Martin)/Daten von Werntges/sample_demoboard.xml" )
@prj = KNXproject.load( "/Users/Tim/Documents/Studium (Bachelor)/8.Semester/"\
                        "Thesis (Werntges + Martin)/Daten von Werntges/heim_c22.xml" )
#@prj = KNXproject.load( "/Users/Tim/Documents/Studium (Bachelor)/8.Semester/"\
#                        "Thesis (Werntges + Martin)/Daten von Werntges/demoboard_theben.xml" )
@prj.emi_server = emi_server
# Update devices and add devices to emi_server
@prj.attach_devices
devs = @prj.devices
$locations = @prj.locations

# Print
# puts "devices: ", @prj.devices
# puts "locations: ", @prj.locations
# puts "org_units: ", @prj.org_units
# puts "group_addresses: ", @prj.group_addresses
# puts "actuators: ", @prj.actuators
# puts "sensors: ", @prj.sensors
# puts "interfaces: ", @prj.interfaces

###################################################################################
# Create Roles, Users, OrgUnits and Accesses in the database                      #
###################################################################################
if ENV['SEEDS']
  connection = ActiveRecord::Base.connection()
  connection.execute("TRUNCATE TABLE roles;")
  connection.execute("TRUNCATE TABLE users;")
  connection.execute("TRUNCATE TABLE users_roles;")
  connection.execute("TRUNCATE TABLE org_units;")
  connection.execute("TRUNCATE TABLE accesses;")

  # Role name:string
  roles_list = %w[ admin editor observer ]

  roles_list.each do |name|
    Role.create!( name: name )
  end

  # User username:string password:string password_confirmation:string role:int language:string
  users_list = [
      [ "admin", "123456", "123456", 1, "de" ],
      [ "tikoh", "123456", "123456", 2, "de" ],
      [ "user1", "123456", "123456", 3, "en" ],
      [ "user2", "123456", "123456", 2, "de" ],
  ]

  users_list.each do |username, password, password_confirmation, role_id, language|
    user = User.create!( username: username, password: password, password_confirmation: password_confirmation, language: language )
    connection.execute("INSERT INTO users_roles (user_id, role_id) VALUES (#{user.id} , #{role_id});")
  end

  # OrgUnit name:string
  @prj.org_units.each do |key, value|
    OrgUnit.create!( name: value, key: key )
  end

  # Access user_id:int org_unit_id:int
  accesses_list = [
      [ 1, 1 ],
      [ 1, 2 ],
      [ 1, 3 ],
      [ 1, 4 ],
      [ 2, 2 ],
      [ 2, 3 ],
      [ 3, 2 ],
      [ 4, 3 ]
  ]
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
  # print "\n\nDev: ", dev, " ouref: ", dev.ouref, "\n"
  # print "desc: ", dev.desc, " listening_to: ", dev.listening_to, "\n"
  # print "parent: ", dev.try(:parent), "\n"
  # print "type: ", dev.try(:type), " dpt: ", dev.try(:dpt), "\n"
  # print "status: ", dev.try(:status), " desc: ", dev.try(:desc), "\n"
  # print "use: ", dev.listening_to.first.try(:use), "\n"

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
  when KNX_Stepper, Slider
    # Ignore, handled by cases above
  when KNX_Toggle
    # Ignore
  when KNX_Value
    # Update to the actual status of the KNX_Value
    dev.update_from_bus
    @text_field = Widget::TextField.new(dev)
    dev.attach( @text_field )
  when KNX_Rocker
    # Ignore
  when KNX_Date
    # Ignore
  when KNX_Time
    # Ignore
  when KNX_Binary
    # Ignore
  when KNX_Setter
    # Ignore
  when KNX_Switch
    # Don't show the switch for the dimmers
    unless dev.parent.is_a? KNX_Dimmer
      # Update to the actual status of the KNX_Switch
      dev.update_from_bus
      @button = Widget::Button.new(dev)
      dev.attach( @button )
    end
  when KNX_Interface
    # Not used for GUI yet
  else
    puts "Class not yet supported: #{dev.class}"
  end
end