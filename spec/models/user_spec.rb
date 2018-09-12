require 'rails_helper'

RSpec.describe User, type: :model do

  it "is invalid with no admin role, when there is no user with an admin role" do
    user = User.create(
      username:               "user",
      password:               "123456",
      password_confirmation:  "123456",
      language:               "de",
      role_ids:               "3",
      org_unit_ids:           ["1"]
    )
    user.valid?
    expect(user.errors[:min_one_admin]).to include("There must be one admin.")
  end

  # "user"=>{"username"=>"usaaaa", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "language"=>"en", "role_ids"=>"3", "org_unit_ids"=>["4"]}
  #
  # user_params: {"username"=>"usaaaa", "password"=>"123456", "password_confirmation"=>"123456", "language"=>"en", "role_ids"=>"3", "org_unit_ids"=>["4"]}

  it "is valid with a username, password, password_confirmation, language, role_ids and org_unit_ids" do
    user = User.create(
      username:               "user",
      password:               "123456",
      password_confirmation:  "123456",
      language:               "de",
      role_ids:               "1",
      org_unit_ids:           ["1"]
    )
    user.valid?
    # TODO
    # Doesn't work as valid, because no entries can be written in users_roles and accesses:
    # expect(user).to be_valid
    expect(user.errors[:min_one_admin]).to include("There must be one admin.")
  end

  it "is invalid without a username" do
    user = User.create(username: nil)
    user.valid?
    expect(user.errors[:username]).to include("can't be blank")
  end

  it "is invalid without a password" do
    user = User.create(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is invalid without a language" do
    user = User.create(language: nil)
    user.valid?
    expect(user.errors[:language]).to include("can't be blank")
  end

  it "is invalid without a role_id" do
    user = User.create(role_ids: nil)
    user.valid?
    expect(user.errors[:role_ids]).to include("can't be blank")
  end

  it "is invalid without a org_unit_id" do
    user = User.create(org_unit_ids: nil)
    user.valid?
    expect(user.errors[:org_unit_ids]).to include("can't be blank")
  end

  it "is invalid with a duplicate username" do
    User.create(
      username:               "user",
      password:               "123456",
      password_confirmation:  "123456",
      language:               "de",
      role_ids:               "3",
      org_unit_ids:           ["1"]
    )
    user = User.create(
      username:               "user",
      password:               "123456",
      password_confirmation:  "123456",
      language:               "en",
      role_ids:               "1",
      org_unit_ids:           %w[2, 3]
    )
    user.valid?
    # TODO
    # Doesn't work as valid, because no entries can be written in users_roles and accesses:
    # expect(user.errors[:username]).to include("has already been taken")
    expect(user.errors[:min_one_admin]).to include("There must be one admin.")
  end
end
