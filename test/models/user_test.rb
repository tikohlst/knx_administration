require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               "1",
        org_unit_ids:           ["1"]
    )
    assert user.valid?
  end

  test 'invalid without username' do
    user = User.create(
        username:               nil,
        password:               "123456",
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               "1",
        org_unit_ids:           ["1"]
    )
    refute user.valid?
    assert_not_nil user.errors[:username]
  end

  test 'invalid without password' do
    user = User.create(
        username:               "user",
        password:               nil,
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               "1",
        org_unit_ids:           ["1"]
    )
    refute user.valid?
    assert_not_nil user.errors[:password]
    assert_not_nil user.errors[:password_confirmation]
  end

  test 'invalid without language' do
    user = User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               nil,
        role_ids:               "1",
        org_unit_ids:           ["1"]
    )
    refute user.valid?
    assert_not_nil user.errors[:language]
  end

  test 'invalid without role_id' do
    user = User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               nil,
        org_unit_ids:           ["1"]
    )
    refute user.valid?
    assert_not_nil user.errors[:role_ids]
  end

  test 'invalid without org_unit_id' do
    user = User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               "1",
        org_unit_ids:           nil
    )
    refute user.valid?
    assert_not_nil user.errors[:org_unit_ids]
  end

  test 'invalid with a duplicate username' do
    User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               "de",
        role_ids:               "2",
        org_unit_ids:           ["1"]
    )
    user = User.create(
        username:               "user",
        password:               "123456",
        password_confirmation:  "123456",
        language:               "en",
        role_ids:               "3",
        org_unit_ids:           %w[2, 3]
    )
    refute user.valid?
    assert_not_nil user.errors[:username]
  end
end
