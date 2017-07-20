class ApplicationController < ActionController::Base

  include SessionsHelper
  protect_from_forgery with: :exception

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "TODO: please login to continue"
      redirect_to(login_url)
    end
  end

  def agent_user
    if current_user.agent_id.blank?
      flash[:danger] = "TODO: please register as an agent to continue"
      redirect_to edit_user(current_user)
    end
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "TODO: no access"
      redirect_to root_path
    end
  end
end
