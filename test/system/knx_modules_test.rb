require "application_system_test_case"

class KnxModulesTest < ApplicationSystemTestCase
  setup do
    @knx_module = knx_modules(:one)
  end

  test "visiting the index" do
    visit knx_modules_url
    assert_selector "h1", text: "Knx Modules"
  end

  test "creating a Knx module" do
    visit knx_modules_url
    click_on "New Knx Module"

    fill_in "Name", with: @knx_module.name
    click_on "Create Knx module"

    assert_text "Knx module was successfully created"
    click_on "Back"
  end

  test "updating a Knx module" do
    visit knx_modules_url
    click_on "Edit", match: :first

    fill_in "Name", with: @knx_module.name
    click_on "Update Knx module"

    assert_text "Knx module was successfully updated"
    click_on "Back"
  end

  test "destroying a Knx module" do
    visit knx_modules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Knx module was successfully destroyed"
  end
end
