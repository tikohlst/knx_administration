class Widget < ApplicationRecord
  include KNX

  class Button
    attr_reader :id, :status, :desc, :org_unit, :location, :device
    attr_writer :status

    # Get all Widget::Button objects
    def self.all
      ObjectSpace.each_object(self).to_a
    end

    # Count all Widget::Button objects
    def self.count
      all.count
    end

    # Initialize a new widget with a device
    def initialize(device)
      @id = self.class.count
      @status = device.status == :on ? 1 : 0
      @desc = device.desc
      @org_unit = device.ouref
      @location = device.parent.locref
      @device = device
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param
      self.device.send(:toggle)
    end

    # Find the widget by the id
    def self.find_by_id(id)
      Widget::Button.all.select{|widget| widget.id.to_i == id.to_i }.first
    end

    # Find all widgets by the org units
    def self.find_by_org_units(org_units)
      buttons = []
      org_units.each do |org_unit|
        # Select all widgets with the allowed org units
        buttons << Widget::Button.all.select{|widget| widget.org_unit.to_s == org_unit.to_s }
      end
      buttons.flatten
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual devise
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = (status == :on ? 1.0 : 0.0).to_i
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "button", id: self.id, status: @widget.status}
    end
  end

  class Slider
    def knx_update( status )
    end
  end

  class ProgressBar
    def knx_update( status )
    end
  end

  class TextField
    def knx_update( status )
    end
  end
end
