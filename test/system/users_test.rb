require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    # Sign in as user 'one'
    visit "en/my/users/sign_in"
    fill_in "Username", with: @user.username
    fill_in "Password", with: "123456"
    click_button "Log in"
    # Add Org-Unit for user 'one'
    visit "en/users/1/edit"
    find(:css, '#org_unit_id_1').click
    click_button "Update"
  end

  test "visiting the index" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # visit users_url
    # puts widgets_url
    # puts users_url
    # puts users_path
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # visit users_url
    # puts widgets_url
    # puts users_url
    # puts users_path
    click_on "New User"

    fill_in "user_username", with: "user_three"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    find(:css, '#user_language_en').find(:xpath, '..').click
    select "editor", from: "user_role_ids"
    select "editor", from: "user_role_ids"
    find(:css, '#org_unit_id_1').click
    click_button "Create"

    assert_text "User was successfully created"
  end

  test "updating a User" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # visit users_url
    # puts widgets_url
    # puts users_url
    # puts users_path
    find(:css, 'tbody tr:last-child').click

    fill_in "user_username", with: "user_two_edited"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    find(:css, '#user_language_en').find(:xpath, '..').click
    select "admin", from: "user_role_ids"
    find(:css, '#org_unit_id_2').click
    click_button "Update"

    assert_text "User was successfully updated"
  end

  test "destroying a User" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # visit users_url
    # puts widgets_url
    # puts users_url
    # puts users_path
    find(:css, 'tbody tr:last-child').click

    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end

  test "updating the own account" do
    visit "en/my/users/edit"
    fill_in "user_username", with: "user_updated"
    fill_in "user_current_password", with: "123456"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    find(:css, '#user_language_en').find(:xpath, '..').click
    click_button "Update"

    assert_text "Your account has been updated successfully"
  end

  test "destroying the own account" do
    visit "en/my/users/edit"
    page.accept_confirm do
      click_on "Cancel my account", match: :first
    end

    assert_text "You need to sign in or sign up before continuing."
  end

  test "searching for user" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # visit users_url
    # puts widgets_url
    # puts users_url
    # puts users_path
    fill_in "term", with: "user_one"
    click_on "Search"

    assert_selector "td", text: "user_one"
    assert_no_selector "td", text: "user_two"
  end
end
