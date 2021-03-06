require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = User.new(first_name: "Test", last_name: "Test",
      email: "test@test.com",
      agent_id: "1.999",
      password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "invalid user signup" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { email: @user.email, password: "123",
        password_confirmation: "123" } }
    end
    assert_template 'users/new'
  end

  test "user signup" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          first_name: @user.first_name,
          last_name: @user.last_name,
          email: @user.email,
          agent_id: "99.99.99",
          password: "1234567",
          password_confirmation: "1234567"
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    # Attempt login before account activation.
    log_in(user)
    assert_not logged_in?

    # Account activation using wrong token.
    get edit_account_activation_url(user.activation_token[0..-2], email:
      user.email)
    assert_not logged_in?

    # Account activation using wrong email.
    get edit_account_activation_url(user.activation_token, email:
      user.email[0..-2])
    assert_not logged_in?

    # Valid account activation.
    get edit_account_activation_url(user.activation_token, email: user.email)
    assert user.reload.activated
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end
