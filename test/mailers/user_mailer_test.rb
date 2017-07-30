require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = users(:admin)
  end

  test "password_reset" do
    @user.password_reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match @user.password_reset_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
    assert_match "Password reset", mail.body.encoded
    assert_match @user.first_name, mail.body.encoded
  end

  test "account_activation" do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)
    assert_equal "Account activation", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
    assert_match "Account activation", mail.body.encoded
    assert_match @user.first_name, mail.body.encoded
  end

end
