require "application_system_test_case"

class WidgetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    # Sign in as user one
    visit "en/my/users/sign_in"
    fill_in "Username", with: @user.username
    fill_in "Password", with: "123456"
    click_button "Log in"
    # Add Org-Unit for user one
    visit "en/users/1/edit"
    find(:css, '#org_unit_id_1').click
    click_button "Update"
  end

  test "visiting the index" do
    visit "en/widgets"
    assert_selector "div", text: "Sort by:"
  end

  test "changing the sort algorithm to 'Org-Unit'" do
    visit "en/widgets"
    find(:css, '#option1').find(:xpath, '..').click
    assert_selector "div", id: "sort_by_org_units"
  end

  test "changing the sort algorithm to 'Location'" do
    visit "en/widgets"
    find(:css, '#option2').find(:xpath, '..').click
    assert_selector "div", id: "sort_by_locations"
  end

  test "changing the sort algorithm to 'A-Z'" do
    visit "en/widgets"
    find(:css, '#option3').find(:xpath, '..').click
    assert_selector "div", id: "sort_alphabetically"
  end

  test "changing the sort algorithm to 'Z-A'" do
    visit "en/widgets"
    find(:css, '#option4').find(:xpath, '..').click
    assert_selector "div", id: "sort_alphabetically"
  end
end
