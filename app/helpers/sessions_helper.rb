module SessionsHelper

  def current_user
    if (user_id = session[:user_id])
      user ||= User.find_by(id: session[:user_id])
      return user
    end
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticate_token?(:remember_me_token,
        cookies[:remember_me_token])
        log_in user
        return user
      end
    end
    return nil
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!current_user
  end

  def log_out
    session.delete(:user_id)
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_me_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
