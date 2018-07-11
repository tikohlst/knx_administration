# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ruby encoding: utf-8
connection = ActiveRecord::Base.connection()
connection.execute("TRUNCATE TABLE administrates;")
connection.execute("TRUNCATE TABLE knx_modules;")
connection.execute("TRUNCATE TABLE roles;")
connection.execute("TRUNCATE TABLE rooms;")
connection.execute("TRUNCATE TABLE rules;")
connection.execute("TRUNCATE TABLE users;")
connection.execute("TRUNCATE TABLE users_roles;")
connection.execute("TRUNCATE TABLE widgets;")

# Role name:string
roles_list = %w[ admin editor observer ]

roles_list.each do |name|
  Role.create!( name: name )
end

# User email:string password:string password_confirmation:string roles:int_array
users_list = [
    [ "admin", "123456", "123456", [ 1, 2, 3 ] ],
    [ "tikoh", "123456", "123456", [ 2, 3 ] ],
    [ "user1", "123456", "123456", [ 3 ] ],
    [ "user2", "123456", "123456", [ 2, 3 ] ],
]

users_list.each do |username, password, password_confirmation, role_ids|
  u = User.create!( username: username, password: password, password_confirmation: password_confirmation )

  role_ids.each do |role_id|
    connection.execute("INSERT INTO users_roles (user_id, role_id) VALUES (#{u.id} , #{role_id});")
  end
end


# Room name:string
rooms_list = %w[ Wohnzimmer Schlafzimmer ]

rooms_list.each do |name|
  Room.create!( name: name )
end

# Administrate user_id:integer room_id:integer
administrates_list = [
    [1, 1],
    [1, 2],
    [2, 1],
    [2, 2],
    [3, 1],
    [3, 2],
    [4, 1]
]

administrates_list.each do |user_id, room_id|
  Administrate.create!( user_id: user_id, room_id: room_id )
end

# KnxModule name:string
knxmodules_list = %w[ KNX1 KNX2 KNX3 ]

knxmodules_list.each do |name|
  KnxModule.create!( name: name )
end

# Widget name:string active:boolean knx_module_id:integer room_id:integer
widgets_list = [
    ["Widget1", 1, 1, 1],
    ["Widget2", 1, 2, 2],
    ["Widget3", 1, 3, 1]
]

widgets_list.each do |name, active, knx_module_id, room_id|
  Widget.create!( name: name, active: active, knx_module_id: knx_module_id, room_id: room_id )
end

# Rule name:string status:boolean start_value:integer end_value:integer steps:float widget_id:integer
rules_list = [
    ["Rule1", 1, 20, 40, 2.5, 1],
    ["Rule2", 0, 1, 10, 1, 2],
    ["Rule3", 1, 0, 1, 0.1, 3]
]

rules_list.each do |name, status, start_value, end_value, steps, widget_id|
  Rule.create!( name: name, status: status, start_value: start_value, end_value: end_value, steps: steps, widget_id: widget_id )
end
