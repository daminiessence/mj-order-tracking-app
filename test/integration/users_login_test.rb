require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:faithess)
  end

  test "invalid login attempt" do
    get login_path
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "valid login and logout procedure" do
    get login_path
    post login_path, params: { session: { email: @user.email,
      password: "password" } }
    assert logged_in?
    delete logout_path
    assert_not logged_in?
  end
end
