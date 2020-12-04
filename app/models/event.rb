class ShortTermSchedule
  attr_accessor :time_begin, :time_end, :room_profile_id

  def initialize(time_begin, time_end, room_profile_id)
    @time_begin = time_begin
    @time_end = time_end
    @room_profile_id = room_profile_id
  end
end

class Event < ApplicationRecord
  require 'date'
  require 'json'
  require 'rexml/document'
  include KNX4R
  include ::EventConcern

  def self.write_schedules
    dir = get_json

    # Define all arrays and variables
    schedules = []
    room_profile_id = 0
    schedule_counter = 0

    lecture_time_start = '2020-03-14'
    lecture_time_end   = '2020-07-10'

    actual_weekday_id = case Date.today.wday
                        when 0
                          5_614_978   # Sunday
                        when 1
                          5_209_085   # Monday
                        when 2
                          4_600_238   # Tuesday
                        when 3
                          5_209_078   # Wednesday
                        when 4
                          4_600_244   # Thursday
                        when 5
                          4_735_545   # Friday
                        when 6
                          5_614_964   # Saturday
                        else
                          0
                        end

    actual_json = "dailywget#{Date.today.year}"\
              "#{format('%02<month>i', month: Date.today.month)}"\
              "#{format('%02<day>i', day: Date.today.day)}.json"

    ################################################################
    # Write the new schedules in the XML configuration file

    # Read the saved occupancy data and save the important parameters in models
    JSON.parse(File.read("#{dir}#{actual_json}"))['ttus'].each do |hash|
      next if hash['weekday_id'] != actual_weekday_id

      time_begin = substract_time(hash['time_begin'], '00:05')
      time_end = add_time(hash['time_end'], '00:05')

      hash['instructors'].each do |array|
        room_profile_id = array['instructor']['room_profile_id']
      end
      schedules << ShortTermSchedule.new(time_begin, time_end, room_profile_id)
    end

    # Read the old XML configuration knx_config.xml
    @items = Nokogiri::XML(File.read(Rails.root.join('config', 'knx_config.xml').to_s))

    # Remove the existing schedules
    @items.xpath('//KNXproject/schedules/schedule').each(&:remove)

    # Create new schedules based on the data from the schedule models
    @items.xpath('//KNXproject/schedules/scenes').each do |node|
      schedules.each do |schedule|
        # Create a new XML schedule and add the parameters:
        # active, valid_from and valid_to
        xml_schedule = Nokogiri::XML::Node.new 'schedule', @items
        xml_schedule['active'] = 'true'
        xml_schedule['valid_from'] = lecture_time_start
        xml_schedule['valid_to'] = lecture_time_end

        # Create a new child 'task' in the XML schedule and add the parameters:
        # scenes, hours, minutes and duration
        xml_schedule.add_child('<task/>')
        xml_schedule.first_element_child['scenes'] =  case schedule.room_profile_id
                                                      when 0
                                                        'B002_default'
                                                      when 1
                                                        'B002_beamer'
                                                      when 2
                                                        'B002_blackboard'
                                                      else
                                                        'B002_default'
                                                      end
        xml_schedule.first_element_child['hours'] \
        = get_hours(schedule.time_begin)
        xml_schedule.first_element_child['minutes'] \
        = get_minutes(schedule.time_begin)
        # Calculation of the lecture duration
        duration = substract_time(schedule.time_end, schedule.time_begin)
        xml_schedule.first_element_child['duration'] \
        = "PT#{get_hours(duration)}H#{get_minutes(duration)}M00S"

        # Create a new child 'desc' in the XML schedule
        # and add a counter as content
        xml_schedule.add_child('<desc/>')
        xml_schedule.last_element_child.content = "schedule #{schedule_counter}"
        schedule_counter += 1

        # Add the new XML schedule to the XML node
        node.add_next_sibling(xml_schedule)
      end
    end

    # Write the schedules for the current day in the XML configuration
    file = File.open(Rails.root.join('config', 'knx_config.xml').to_s, 'w')
    file.puts @items.to_xml
    file.close
  end

  def self.start_schedules(emi_server)
    # Reload the configuration file and start the schedules
    prj = KNXproject.load(Rails.root.join('config', 'knx_config.xml').to_s)
    prj.emi_server = emi_server
    # Add devices (actuators + sensors + interfaces) to emi_server
    prj.attach_devices
    # Start the schedules
    prj.run
  end
end
