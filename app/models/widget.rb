class Widget
  include KNX

  attr_reader :id, :desc, :org_unit, :location, :use, :dpt

  def initialize(device)
    @id = self.class.all_widgets.count
    @desc = device.desc
    @org_unit = device.ouref
    @location = device.parent.locref
    @use = device.listening_to.first.try(:use)
    @dpt = device.try(:dpt)
  end

  # Get all widget objects
  def self.all_widgets
     Widget::Button.all + Widget::ProgressBar.all + Widget::Slider.all + Widget::TextField.all
  end

  # Find the widget by the id (class method)
  def self.find_by_id(id)
    all_widgets.select{|widget| widget.id.to_i == id.to_i }.first
  end

  def self.find(id)
    self.find_by_id(id)
  end

  # Find all widgets by the org units
  def self.find_by_org_units(org_units)
    widgets = []
    org_units = org_units.flatten
    org_units.each do |org_unit|
      # Select all widgets with the allowed org units
      widgets << self.all.select{|widget| widget.org_unit.to_s == org_unit.to_s }
    end
    widgets.flatten
  end

  # Buttons for lightings
  class Button < Widget
    attr_accessor :status
    attr_reader :device

    # Initialize a new widget with a device
    def initialize(device)
      super
      @status = device.status == :on ? 1 : 0
      @device = device
    end

    # Get all Widget::Button objects
    def self.all
      ObjectSpace.each_object(self).to_a
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual device
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = (status == :on ? 1.0 : 0.0).to_i
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "button", id: self.id, status: @widget.status}
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param
      self.device.send(:toggle)
    end
  end

  # ProgressBars for shutters and blinds
  class ProgressBar < Widget
    attr_accessor :status
    attr_reader :device

    # Initialize a new widget with a device
    def initialize(device)
      super
      @status = {position: 0, slider_status: :stopped}
      @device = device
    end

    # Get all Widget::ProgressBar objects
    def self.all
      ObjectSpace.each_object(self).to_a
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual device
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = {position: (status.position * 100).to_i, slider_status: status.slider_status}
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "progressBar", id: self.id, status: @widget.status}
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param(direction)
      case direction
      when "step_backward"
        self.device.send(:decrease)
      when "backward"
        self.device.send(:up)
      when "forward"
        self.device.send(:down)
      when "step_forward"
        self.device.send(:increase)
      else
        puts "Error: No valid direction"
      end
    end
  end

  # Sliders for dimmers and radiators
  class Slider < Widget
    attr_accessor :status
    attr_reader :device

    # Initialize a new widget with a device
    def initialize(device)
      super
      @status = 0
      @device = device
    end

    # Get all Widget::Slider objects
    def self.all
      ObjectSpace.each_object(self).to_a
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual device
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = status
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "slider", id: self.id, status: @widget.status}
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param(value)
      self.device.send(:set_to, value)
    end
  end

  class TextField < Widget
    attr_accessor :status

    # Initialize a new widget with a device
    def initialize(device)
      super
      @status = 0
    end

    # Get all Widget::TextField objects
    def self.all
      ObjectSpace.each_object(self).to_a
    end

    # Gets called when a telegram was send from the knx-bus
    def knx_update(status)
      # Find widget for actual device
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = case status
                       when Float
                         "%8.2f" % [status]
                       else
                         status.to_s
                       end
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "textField", id: self.id, status: @widget.status, dpt: @widget.dpt, desc: @widget.desc}
    end
  end
end
