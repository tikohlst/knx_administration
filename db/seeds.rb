# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ruby encoding: utf-8
connection = ActiveRecord::Base.connection()
connection.execute("TRUNCATE TABLE roles;")
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

# Widget name:string active:boolean use:string value:float
widgets_list = [
    ["DG AZi Süd", 1, "lighting", 1],
    ["DG AZi Ost", 1, "lighting", 1],
    ["DG AZi Mitte/Wand", 1, "lighting", 1],
    ["DG Speicher", 1, "lighting", 1],
    ["DG SchZi", 1, "lighting", 1],
    ["DG SchZi Schrank", 1, "lighting", 1],
    ["DG Bad", 1, "lighting", 1],
    ["DG Treppenhaus", 1, "lighting", 1],
    ["OG Treppenhaus", 1, "lighting", 1],
    ["OG Bad 1", 1, "lighting", 1],
    ["OG Bad 2", 1, "lighting", 1],
    ["OG Gästezimmer", 1, "lighting", 1],
    ["KE Treppenhaus", 1, "lighting", 1],
    ["KE Übergaberaum", 1, "lighting", 1],
    ["KE Anja 1", 1, "lighting", 1],
    ["KE Anja 2", 1, "lighting", 1],
    ["KE Großer Keller", 1, "lighting", 1],
    ["KE Bad Decke", 1, "lighting", 1],
    ["KE Bad Becken", 1, "lighting", 1],
    ["EG Diele", 1, "lighting", 1],
    ["EG Küche 1", 1, "lighting", 1],
    ["EG Küche 2", 1, "lighting", 1],
    ["EG WZi Nord 1", 1, "lighting", 1],
    ["EG WZi Nord 2", 1, "lighting", 1],
    ["EG WZi Süd 1", 1, "lighting", 1],
    ["EG WZi Süd 2", 1, "lighting", 1],
    ["EG Terrasse", 1, "lighting", 1],
    ["OG KiZi Süd 1", 1, "lighting", 1],
    ["OG KiZi Süd 2", 1, "lighting", 1],
    ["OG KiZi Nord 1", 1, "lighting", 1],
    ["OG KiZi Nord 2", 1, "lighting", 1],

    ["DG AZi Ost", 1, "shutter", 35],
    ["DG AZi Süd", 1, "shutter", 100],
    ["DG AZi West", 1, "shutter", 100],
    ["DG Treppenhaus", 1, "shutter", 100],
    ["DG Bad", 1, "shutter", 0],
    ["DG SchZi", 1, "shutter", 100],
    ["OG Nord", 1, "shutter", 0],
    ["OG Süd Fenster", 1, "shutter", 100],
    ["OG Süd Tür", 1, "shutter", 100],
    ["OG Gäste Fenster", 1, "shutter", 100],
    ["OG Gäste Tür", 1, "shutter", 100],
    ["OG Süd Markise", 1, "shutter", 100],

    ["OG Süd Markise", 1, "blind", 52],

    ["KE Bad Becken", 1, "dimmer", 88],

    ["Wasser im Keller", 1, "mc", 0],

    ["DG Bad", 1, "window", 1],
    ["DG TrHaus", 1, "window", 1],
    ["DG SchZi", 1, "window", 1],

    ["Temperatur", 1, "weather", 27.3],
    ["Windgeschwindigkeit", 1, "weather", 22.1],
    ["Helligkeit", 1, "weather", 12.8]
]

widgets_list.each do |name, active, use, value|
  Widget.create!( name: name, active: active, use: use, value: value )
end
