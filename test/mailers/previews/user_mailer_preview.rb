# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # (http://localhost:3000/rails/mailers/user_mailer/password_reset).
  def password_reset
    user.password_reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  # Preview this email at
  # (http://localhost:3000/rails/mailers/user_mailer/account_activation).
  def account_activation
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  private

    def user
      @user ||= User.first || User.new(email: "email@email.com", password:
        "1234567", password_confirmation: "1234567")
    end
end
