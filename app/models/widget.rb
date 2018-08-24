class Widget < ApplicationRecord
  include KNX

  class Button
    attr_reader :id, :status, :desc, :device
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
      @device = device
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param
      self.device.send(:toggle)
    end

    # Find the widget by the id
    def self.find(id)
      Widget::Button.all.select{|widget| widget.id.to_i == id.to_i }.first
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual devise
      @widget = self.class.find(self.id)
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
