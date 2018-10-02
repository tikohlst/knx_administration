require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    visit "en/my/users/sign_in"
    fill_in "Username", with: @user.username
    fill_in "Password", with: "123456"
    click_button "Log in"
  end

  test "visiting the index" do
    visit "en/users"
    # TODO: Can't print urls or paths => I think this is the problem
    # puts widgets_url
    # puts users_url
    # puts users_path
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit "en/users"
    #visit users_url
    click_on "New User"

    fill_in "user_username", with: "user_three"
    fill_in "user_password", with: "123456"
    fill_in "user_password_confirmation", with: "123456"
    #find(:css, '#user_language_en < label').click
    #ancestor('#user_language_en').find(:css, 'label').click
    select "editor", from: "user_role_ids"
    select "editor", from: "user_role_ids"
    find(:css, '#org_unit_id_1').click
    click_on "Create"

    assert_text "User was successfully created"
  end

  test "updating a User" do
    #visit "en/users"
    # visit users_url
    #find(:css, '#table_users > tbody > tr:first').click
    #ancestor('#table_users').find(:css, 'tbody').find(:css, 'tr:first').click
    #find('#table_users').find('tbody').find('tr').first.click
    #all('tr').first.click

    visit "en/users/2/edit"
    fill_in "user_username", with: "user_three_edited"
    fill_in "user_password", with: "12345678"
    fill_in "user_password_confirmation", with: "12345678"
    #choose 'user_language_en'
    select "admin", from: "user_role_ids"
    find(:css, '#org_unit_id_2').click
    click_on "Update"

    assert_text "User was successfully updated"
  end

  test "destroying a User" do
    #visit "en/users"
    #visit users_url
    #find(:css, '#table_users > tbody > tr:first').click
    #click_on "observer", match: :first

    visit "en/users/2/edit"
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end
end
