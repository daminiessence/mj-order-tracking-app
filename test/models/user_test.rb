require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new email: "faithy@email.com", password: "1234567",
      password_confirmation: "1234567"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    empty_values = [ nil, "", " " ]
    empty_values.each do |val|
      @user.email = val
      assert_not @user.valid?
    end
  end

  test "email should reject invalid emails" do
    invalid_emails = [ "email", "email@", "email@.com", "email.com",
      "email@emailcom", "email @email.com" ]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?
    end
  end

  test "email should accept valid emails" do
    valid_emails = %w[ email@email.com email@a.b.c a@b.c 123@abc.haha ]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?
    end
  end

  test "email should be unique" do
    diff_pass = @user.password + "abc"
    another_user = User.new(password: diff_pass,
      password_confirmation: diff_pass)
    another_user.email = @user.email
    @user.save
    assert_not another_user.valid?
  end

  test "password should be present" do
    [ nil, "", " " * 7 ].each do |pword|
      @user.password = @user.password_confirmation = pword
      assert_not @user.valid?
    end
  end

  test "password should be more than 6 characters long" do
    @user.password = @user.password_confirmation = "a" * 6
    assert_not @user.valid?
  end
end
