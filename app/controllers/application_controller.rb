class ApplicationController < ActionController::Base

  include SessionsHelper
  protect_from_forgery with: :exception
  add_breadcrumb "home", :root_path

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "TODO: please login to continue"
      redirect_to(login_url)
    end
  end

  def agent_user
    unless current_user.verified_agent?
      parent_agent_id = current_user.agent_id.gsub(/\.\d+\z/, "")
      p_agent = User.find_by(agent_id: parent_agent_id)
      flash[:danger] = "You are not a verified agent! Please ask #{p_agent.first_name} "\
        "#{p_agent.last_name} (ID: #{p_agent.agent_id}) to verify your ID before continuing."
      redirect_back_or(root_url)
    end
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "TODO: no access"
      redirect_to root_path
    end
  end
end
