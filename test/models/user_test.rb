require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new first_name: "Fai", last_name: "Atara",
      email: "faithy@email.com",
      agent_id: "999",
      password: "password",
      password_confirmation: "password"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first_name should not have leading and trailing whitespaces" do
    f_names = [ " Fyyy", "Fyyy ", " Fyyy " ]
    f_names.each do |fn|
      @user.first_name = fn
      assert_not @user.valid?
    end
  end

  test "first_name should be present and valid" do
    invalid_first_names = [ nil, "", " " ]
    invalid_first_names.each do |fn|
      @user.first_name = fn
      assert_not @user.valid?
    end
  end

  test "last_name should not have leading and trailing whitespaces" do
    l_names = [ " Atarah", "Atarah ", " Atara " ]
    l_names.each do |ln|
      @user.last_name = ln
      assert_not @user.valid?
    end
  end

  test "last_name should be present and valid" do
    invalid_last_names = [ nil, "", " " ]
    invalid_last_names.each do |ln|
      @user.last_name = ln
      assert_not @user.valid?
    end
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
    assert @user.save
    another_user = @user.dup
    another_user.agent_id += ".1"
    assert_not another_user.valid?
    another_user.email += ".ca"
    assert another_user.valid?
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

  test "agent_id should be present" do
    @user.agent_id = nil
    assert_not @user.valid?
  end

  test "agent_id should be of valid format" do
    invalid_agent_ids = [ "faithess.atarah", "1.", "1.a", "a.1", "00.1", "-1", "1..0" ]
    invalid_agent_ids.each do |invalid_agent_id|
      @user.agent_id = invalid_agent_id
      assert_not @user.valid?
    end
  end

  test "agent_id should be unique" do
    assert @user.save
    another_agent = @user.dup
    another_agent.email += ".ca"
    assert_not another_agent.valid?
    another_agent.agent_id += ".1"
    assert another_agent.valid?
  end
end
