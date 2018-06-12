require 'test_helper'

class AdministratesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrate = administrates(:one)
  end

  test "should get index" do
    get administrates_url
    assert_response :success
  end

  test "should get new" do
    get new_administrate_url
    assert_response :success
  end

  test "should create administrate" do
    assert_difference('Administrate.count') do
      post administrates_url, params: { administrate: { room_id: @administrate.room_id, user_id: @administrate.user_id } }
    end

    assert_redirected_to administrate_url(Administrate.last)
  end

  test "should show administrate" do
    get administrate_url(@administrate)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrate_url(@administrate)
    assert_response :success
  end

  test "should update administrate" do
    patch administrate_url(@administrate), params: { administrate: { room_id: @administrate.room_id, user_id: @administrate.user_id } }
    assert_redirected_to administrate_url(@administrate)
  end

  test "should destroy administrate" do
    assert_difference('Administrate.count', -1) do
      delete administrate_url(@administrate)
    end

    assert_redirected_to administrates_url
  end
end
