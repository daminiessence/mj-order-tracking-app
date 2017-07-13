require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  fixtures :all

  def logged_in?
    !session[:user_id].nil?
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest

  def log_in(user, password: "password", remember_me: "0")
    post login_path, params: { session: { email: user.email, password: password,
      remember_me: remember_me } }
  end
end
