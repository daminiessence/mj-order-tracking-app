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
    assert_not flash.empty?
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
  end

  test "login with remembering" do
    log_in(@user, remember_me: "1")
    assert_not_empty cookies["remember_me_token"]
  end

  test "login without remembering" do
    log_in(@user, remember_me: "1")
    log_in(@user, remember_me: "0")
    assert_empty cookies["remember_me_token"]
  end
end
