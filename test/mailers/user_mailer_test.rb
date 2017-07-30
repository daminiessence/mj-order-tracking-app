require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = users(:admin)
  end

  test "password_reset" do
    @user.password_reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "Password Reset", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match @user.password_reset_token, mail.body.encoded
    assert_match @user.email, mail.body.encoded
  end

  test "account_activation" do
    mail = UserMailer.account_activation
    # assert_equal "Account activation", mail.subject
    # assert_equal ["to@example.org"], mail.to
    # assert_equal ["from@example.com"], mail.from
    # assert_match "Hi", mail.body.encoded
  end

end
