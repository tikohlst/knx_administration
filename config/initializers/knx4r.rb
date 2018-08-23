###################################################################################
# Initialize KNXnetIP connection                                                  #
###################################################################################
require 'knx4r'
require 'rexml/document'
include KNX

$lightings = []
$boards = []
$widgets = []

@gw = KNXnetIP::Gateway.new( clientHostIP: "10.200.73.20" || ENV['HOST_IP'])
emi_server = CEMI_Server.new
logger = KNX::KNX_Logger.new(desc: 'L_Data logger')
emi_server.attach_logger( logger )
@gw.attach( emi_server )
@gw.connect( @gw.find || {} )

@prj = KNXproject.load("/Users/Tim/Documents/Studium (Bachelor)/8.Semester/"\
                       "Thesis (Werntges + Martin)/Daten von Werntges/sample_demoboard.xml" )
#@prj = KNXproject.load( "/Users/Tim/Documents/Studium (Bachelor)/8.Semester/"\
#                        "Thesis (Werntges + Martin)/Daten von Werntges/heim_c22.xml" )
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
    OrgUnit.create!( name: value )
  end

  # Access user_id:int org_unit_id:int
  accesses_list = [
      [ 1, 1 ],
      [ 1, 2 ],
      [ 1, 3 ],
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
  ouref = dev.ouref
  # print "\n\nDev: ", dev, " ouref: ", ouref, "\n"
  # print "desc: ", dev.desc, " listening_to: ", dev.listening_to, "\n"
  # print "id: ", dev.id, " parent: ", dev.try(:parent), "\n"
  # print "type: ", dev.try(:type), " label: ", dev.try(:label), "\n"
  # print "status: ", dev.try(:status), " desc: ", dev.try(:desc), "\n"
  # print "use: ", dev.try(:use), " dpt: ", dev.try(:dpt), "\n"
  #print "power:", dev.status.power, " settable:", dev.settable, "\n\n\n"

  case dev
  when KNX::KNX_Driver, KNX::KNX_DimmerDriver
    case pdev = dev.parent
    when KNX::KNX_Blind
      puts "\n\nBlind\n\n"
      wid = Widget.new(id: 2, name: "Green light", use: "blind", value: dev.status,
                       location: "DG AZi")
      $widgets.push(wid)
    when KNX::KNX_Dimmer then puts "\n\nDimmer\n\n"
    else raise "Unknown parent: #{pdev.class}"
    end

  when KNX::KNX_Stepper, KNX::Slider
    # Ignore, handled by cases above

  when KNX::KNX_Sensor
    matching_ga = @prj.group_addresses.values.find do |ga|
      ga.value==dev.listening_to.first.value
    end
    fail "Group address missing: #{dev.listening_to.first}" unless matching_ga

    case matching_ga.use
    when 'Lighting'
      puts "KNX::KNX_Sensor : Lighting"
      #$lightings.push(dev)
    when 'Weather'
      puts "KNX::KNX_Sensor : Weather"
    when 'Monitoring_Control'
      puts "KNX::KNX_Sensor : Monitoring_Control"
    else next
    end

    case dev
    when KNX::KNX_Binary

    when KNX::KNX_Value, KNX::KNX_Date, KNX::KNX_Time

    when KNX::KNX_Toggle
      # Ignore
    else
      raise "Sensor class not yet supported: #{dev.class}"
    end

  when KNX::KNX_Switch
    puts "KNX::KNX_Switch : ", dev, dev.class
    $lightings.push(dev)
    dev.on?
    puts "\n\n\n\n#{dev.status}\nstatus.class:", dev.status.class, "\n\n\n"
    wid = Widget.new(id: 100, name: "Green light", use: "lighting",
                     value: dev.status == :on ? 1 : 0, location: "DG AZi")
    $widgets.push(wid)
    dev.attach( wid )
  else
    #raise "Class not yet supported: #{dev.class}"
    puts "Class not yet supported: #{dev.class}"
  end
end