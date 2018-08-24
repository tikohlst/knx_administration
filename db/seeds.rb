# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ruby encoding: utf-8
connection = ActiveRecord::Base.connection()
connection.execute("TRUNCATE TABLE widgets;")

# Widget name:string active:boolean use:string value:float location:string org_unit_id:int
widgets_list = [
    # lightings
    ["DG AZi Süd", 1, "lighting", 1, "DG AZi", 1],
    ["DG AZi Ost", 1, "lighting", 1, "DG AZi", 1],
    ["DG AZi Mitte/Wand", 1, "lighting", 1, "DG AZi", 1],
    ["DG Speicher", 1, "lighting", 1, "", 1],
    ["DG SchZi", 1, "lighting", 1, "DG SchZi", 2],
    ["DG SchZi Schrank", 1, "lighting", 1, "DG SchZi", 1],
    ["DG Bad", 1, "lighting", 1, "DG Bad", 1],
    ["DG Treppenhaus", 1, "lighting", 1, "DG Treppenhaus", 1],
    ["OG Treppenhaus", 1, "lighting", 1, "", 1],
    ["OG Bad 1", 1, "lighting", 1, "", 1],
    ["OG Bad 2", 1, "lighting", 1, "", 1],
    ["OG Gästezimmer", 1, "lighting", 1, "", 2],
    ["KE Treppenhaus", 1, "lighting", 1, "", 2],
    ["KE Übergaberaum", 1, "lighting", 1, "", 1],
    ["KE Anja 1", 1, "lighting", 1, "", 1],
    ["KE Anja 2", 1, "lighting", 1, "", 2],
    ["KE Großer Keller", 1, "lighting", 1, "", 1],
    ["KE Bad Decke", 1, "lighting", 1, "", 1],
    ["KE Bad Becken", 1, "lighting", 1, "", 2],
    ["EG Diele", 1, "lighting", 1, "", 2],
    ["EG Küche 1", 1, "lighting", 1, "EG Küche", 2],
    ["EG Küche 2", 1, "lighting", 1, "EG Küche", 1],
    ["EG WZi Nord 1", 1, "lighting", 1, "", 2],
    ["EG WZi Nord 2", 1, "lighting", 1, "", 1],
    ["EG WZi Süd 1", 1, "lighting", 1, "", 3],
    ["EG WZi Süd 2", 1, "lighting", 1, "", 3],
    ["EG Terrasse", 1, "lighting", 1, "", 3],
    ["OG KiZi Süd 1", 1, "lighting", 1, "OG KiZi Süd", 3],
    ["OG KiZi Süd 2", 1, "lighting", 1, "OG KiZi Süd", 2],
    ["OG KiZi Nord 1", 1, "lighting", 1, "OG KiZi Nord", 1],
    ["OG KiZi Nord 2", 1, "lighting", 1, "OG KiZi Nord", 1],
    # shutters
    ["DG AZi Ost", 1, "shutter", 35, "DG AZi", 1],
    ["DG AZi Süd", 1, "shutter", 100, "DG AZi", 1],
    ["DG AZi West", 1, "shutter", 100, "DG AZi", 1],
    ["DG Treppenhaus", 1, "shutter", 100, "DG Treppenhaus", 3],
    ["DG Bad", 1, "shutter", 0, "DG Bad", 3],
    ["DG SchZi", 1, "shutter", 100, "DG SchZi", 1],
    ["OG Nord", 1, "shutter", 0, "", 1],
    ["OG Süd Fenster", 1, "shutter", 100, "", 3],
    ["OG Süd Tür", 1, "shutter", 100, "", 2],
    ["OG Gäste Fenster", 1, "shutter", 100, "", 2],
    ["OG Gäste Tür", 1, "shutter", 100, "", 2],
    ["OG Süd Markise", 1, "shutter", 100, "", 2],
    # blinds
    ["OG Süd Markise", 1, "blind", 52, "", 1],
    # dimmer
    ["KE Bad Becken", 1, "dimmer", 88, "", 1],
    # monitoring-control
    ["Wasser im Keller", 1, "mc", 0, "", 1],
    ["Wasser Spülmaschine", 1, "mc", 0, "", 1],
    ["Wasser Obergeschoss", 1, "mc", 0, "", 1],
    ["Wasser Dachgeschoss", 1, "mc", 0, "", 1],
    ["Blitzschutz-Ausfall Zählerschrank", 1, "mc", 0, "", 1],
    ["Blitzschutz-Ausfall PV", 1, "mc", 0, "", 1],
    ["HEMS-Ausfall", 1, "mc", 0, "", 1],
    ["IR-Umsetzer K1", 1, "mc", 0, "", 1],
    ["Datum DCF", 1, "mc", 0, "", 1],
    ["Uhrzeit DCF", 1, "mc", 0, "", 1],
    ["Nachtbeginn!", 1, "mc", 0, "", 1],
    ["Datum/Zeit anfordern!", 1, "mc", 0, "", 1],
    # window
    ["DG Bad", 1, "window", 1, "DG Bad", 1],
    ["DG TrHaus", 1, "window", 1, "", 1],
    ["DG SchZi", 1, "window", 1, "DG SchZi", 1],
    # weather
    ["Temperatur", 1, "weather", 27.3, "", 1],
    ["Windgeschw.", 1, "weather", 22.1, "", 1],
    ["Helligkeit", 1, "weather", 7312.0, "", 1],
    ["Azimut Sonne", 1, "weather", 12.8, "", 1],
    ["Elevation Sonne", 1, "weather", 12.8, "", 1],
    ["Dämmerung", 1, "weather", 12.8, "", 1],
    ["Regenalarm", 1, "weather", 12.8, "", 1],
    ["Anforderung T_min, T_max", 1, "weather", 12.8, "", 1],
    ["T_min", 1, "weather", -17.1, "", 1],
    ["T_max", 1, "weather", 39.4, "", 1],
    ["Anforderung v_max", 1, "weather", 12.8, "", 1],
    ["v_max", 1, "weather", 29.8, "", 1],
    ["Sturm! (v > 20m/s)", 1, "weather", 0, "", 1],
    ["Windalarm Markise", 1, "weather", 12.8, "", 1],
    ["Dunkelheit oder Sturm! (0->1)", 1, "weather", 12.8, "", 1],
    ["Tagesbeginn (1->0)", 1, "weather", 12.8, "", 1]
]

widgets_list.each do |name, active, use, value, location, orgUnitId|
  Widget.create!( name: name, active: active, use: use, value: value, location: location, org_unit_id: orgUnitId )
end
