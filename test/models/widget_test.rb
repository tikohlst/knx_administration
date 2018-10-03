require 'test_helper'
require 'rexml/document'
include KNX

class WidgetTest < ActiveSupport::TestCase
  setup do
    prj = KNXproject.load(Rails.root.join('config', 'knx_config.xml').to_s)
    @devs = prj.devices
  end

  test "method 'all_widgets'" do
    Widget::Button.new(@devs.select { |dev| dev.class == KNX_Switch }.first)
    Widget::ProgressBar.new(@devs.select { |dev| dev.class == KNX_Driver }.first)
    Widget::Slider.new(@devs.select { |dev| (dev.class == KNX_DimmerDriver)}.first)
    Widget::TextField.new(@devs.select { |dev| dev.class == KNX_Value }.first)
    assert (4..10).include? Widget.all_widgets.count
  end

  test "method 'find'" do
    Widget::Button.new(@devs.select { |dev| dev.class == KNX_Switch }.first)
    widget = Widget.find_by_id(1)
    assert widget.id == 1
  end

  test "method 'find_by_org_units'" do
    access_org_units = []
    access_org_units << OrgUnit.where(key: "ou002").pluck(:key)
    Widget::Button.new(@devs.select { |dev| dev.class == KNX_Switch }.first)
    assert (1..4).include? Widget::Button.find_by_org_units(access_org_units).count
  end

  test "method 'Widget::Button.all'" do
    Widget::Button.new(@devs.select { |dev| dev.class == KNX_Switch }.first)
    assert (1..4).include? Widget::Button.all.count
  end


  test "method 'Widget::ProgressBar.all'" do
    Widget::ProgressBar.new(@devs.select { |dev| dev.class == KNX_Driver }.first)
    assert (1..2).include? Widget::ProgressBar.all.count
  end

  test "method 'Widget::Slider.all'" do
    Widget::Slider.new(@devs.select { |dev| (dev.class == KNX_DimmerDriver)}.first)
    assert (1..2).include? Widget::Slider.all.count
  end

  test "method 'Widget::TextField.all'" do
    Widget::TextField.new(@devs.select { |dev| dev.class == KNX_Value }.first)
    assert (1..2).include? Widget::TextField.all.count
  end
end
