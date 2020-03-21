module EventConcern
  extend ActiveSupport::Concern

  class_methods do
    # Get the actual JSON from the AoR
    def get_json
      # directory for the output and the log file
      dir = '/var/www/shared/json/'
      # wget download url
      url = 'https://aortest.local.cs.hs-rm.de/rooms/162137521/plans.json'
      # wget output file
      file = "dailywget`date +\"%Y%m%d\"`.json"
      # wget log file
      logfile = 'dailywget.log'
      # run the actual wget shell command
      system("/usr/bin/wget --no-proxy #{url} -O #{dir}#{file} -o #{dir}#{logfile}")
      return dir
    end

    # Get hours from String time
    def get_hours(time)
      time[/(\d{2}):\d{2}/, 1]
    end

    # Get minutes from String time
    def get_minutes(time)
      time[/\d{2}:(\d{2})/, 1]
    end

    # Substract String time_to_substract from String time
    def substract_time(time, time_to_substract)
      hours = get_hours(time).to_i
      minutes = get_minutes(time).to_i

      substract_hours = get_hours(time_to_substract).to_i
      substract_minutes = get_minutes(time_to_substract).to_i

      hours -= substract_hours

      if minutes < substract_minutes
        hours -= 1
        minutes = 60 - (substract_minutes - minutes)
      else
        minutes -= substract_minutes
      end

      hours = '0' + hours.to_s if hours < 10
      minutes = '0' + minutes.to_s if minutes < 10

      "#{hours}:#{minutes}"
    end

    # Add String time_to_add to String time
    def add_time(time, time_to_add)
      hours = get_hours(time).to_i
      minutes = get_minutes(time).to_i

      additional_minutes = get_minutes(time_to_add).to_i

      minutes += additional_minutes

      if minutes > 60
        hours += 1
        minutes -= 60
      end

      hours = '0' + hours.to_s if hours < 10
      minutes = '0' + minutes.to_s if minutes < 10

      "#{hours}:#{minutes}"
    end
  end
end
