require "application_system_test_case"

class AdministratesTest < ApplicationSystemTestCase
  setup do
    @administrate = administrates(:one)
  end

  test "visiting the index" do
    visit administrates_url
    assert_selector "h1", text: "Administrates"
  end

  test "creating a Administrate" do
    visit administrates_url
    click_on "New Administrate"

    fill_in "Room", with: @administrate.room_id
    fill_in "User", with: @administrate.user_id
    click_on "Create Administrate"

    assert_text "Administrate was successfully created"
    click_on "Back"
  end

  test "updating a Administrate" do
    visit administrates_url
    click_on "Edit", match: :first

    fill_in "Room", with: @administrate.room_id
    fill_in "User", with: @administrate.user_id
    click_on "Update Administrate"

    assert_text "Administrate was successfully updated"
    click_on "Back"
  end

  test "destroying a Administrate" do
    visit administrates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Administrate was successfully destroyed"
  end
end
