class Widget
  include KNX

  attr_reader :id, :desc, :org_unit, :location, :use

  def initialize(device)
    @id = self.class.all_widgets.count
    @desc = device.desc
    @org_unit = device.ouref
    @location = device.parent.locref
    @use = device.listening_to.first.try(:use)
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
    buttons = []
    org_units.each do |org_unit|
      # Select all widgets with the allowed org units
      buttons << self.all.select{|widget| widget.org_unit.to_s == org_unit.to_s }
    end
    buttons.flatten
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
      # Find widget for actual devise
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
      puts "\n\n\n\nProgressBar knx_update: #{status}, #{status.class}, #{status.to_s}, #{status.to_s.class}\n\n\n\n"
      # Find widget for actual devise
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
        self.device.send(:up)
      when "backward"
        self.device.send(:decrease)
      when "forward"
        self.device.send(:increase)
      when "step_forward"
        self.device.send(:down)
      else
        puts "Error: No valid direction"
      end
    end
  end

  # Sliders for dimmers
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
      # Find widget for actual devise
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = status
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "slider", id: self.id, status: @widget.status}
    end

    # Gets called when a telegram should be send to the knx-bus
    def send_param(brightness)
      self.device.send(:set_to, brightness)
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
      # Find widget for actual devise
      @widget = self.class.find_by_id(self.id)
      # Update widget status
      @widget.status = status["status"]
      # Send the update to all running sessions
      ActionCable.server.broadcast 'widgets', {type: "textField", id: self.id, status: @widget.status}
    end
  end
end
