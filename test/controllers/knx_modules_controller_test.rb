require 'test_helper'

class KnxModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @knx_module = knx_modules(:one)
  end

  test "should get index" do
    get knx_modules_url
    assert_response :success
  end

  test "should get new" do
    get new_knx_module_url
    assert_response :success
  end

  test "should create knx_module" do
    assert_difference('KnxModule.count') do
      post knx_modules_url, params: { knx_module: { name: @knx_module.name } }
    end

    assert_redirected_to knx_module_url(KnxModule.last)
  end

  test "should show knx_module" do
    get knx_module_url(@knx_module)
    assert_response :success
  end

  test "should get edit" do
    get edit_knx_module_url(@knx_module)
    assert_response :success
  end

  test "should update knx_module" do
    patch knx_module_url(@knx_module), params: { knx_module: { name: @knx_module.name } }
    assert_redirected_to knx_module_url(@knx_module)
  end

  test "should destroy knx_module" do
    assert_difference('KnxModule.count', -1) do
      delete knx_module_url(@knx_module)
    end

    assert_redirected_to knx_modules_url
  end
end
