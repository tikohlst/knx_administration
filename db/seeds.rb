require 'rexml/document'
include KNX

###################################################################################
# Create Roles, Users, OrgUnits and Accesses in the database                      #
###################################################################################
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
@prj = KNXproject.load(Rails.root.join('config', 'knx_config.xml').to_s)
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
