require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:admin)
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Password reset with unknown email.
    post password_resets_path(@user.password_reset_token), params: {
      password_reset: { email: "invalid@email.com" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Password reset with known user email.
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post password_resets_path(@user.password_reset_token), params: {
        password_reset: { email: @user.email } }
    end
    assert_not_equal @user.password_reset_digest,
      @user.reload.password_reset_digest
    assert_not flash.empty?
    assert_redirected_to root_url

    # Get @user from page.
    user = assigns(:user)

    # Link with wrong email.
    get edit_password_reset_url(user.password_reset_token, params: { email:
      "wrong@email.com" })
    assert_not flash.empty?
    assert_redirected_to root_url

    # TODO: Link for unactivated user.

    # Link with wrong token.
    get edit_password_reset_url(user.password_reset_token.reverse, params: {
      email: user.email })
    assert_not flash.empty?
    assert_redirected_to root_url

    # Link with right token and email.
    get edit_password_reset_url(user.password_reset_token, params: { email:
      user.email })
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # New password != new password confirmation.
    patch password_reset_path(user.password_reset_token, params: { email:
      user.email, user: { password: "new_password_123", password_confirmation:
      "new_password_321" } })
    assert_not flash.empty?

    # Password reset to empty password.
    patch password_reset_path(user.password_reset_token, params: { email:
      user.email, user: { password: "", password_confirmation: "" } })
    assert_not flash.empty?

    # Valid password reset.
    patch password_reset_path(user.password_reset_token, params: { email:
      user.email, user: { password: "new_password_123", password_confirmation:
      "new_password_123" } })
    assert_not flash.empty?
    assert logged_in?
    assert_redirected_to user_path(user.id)
  end
end
