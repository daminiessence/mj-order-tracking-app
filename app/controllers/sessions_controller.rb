class SessionsController < ApplicationController

  def new
    add_breadcrumb "login", login_path
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      if user.agent_id
        flash[:success] = "TODO: login ok"
      else
        flash[:warning] = "TODO: account not activated"
      end
      redirect_back_or root_url
    else
      flash.now[:danger] = "TODO: login not ok"
      render :new
    end
  end

  def destroy
    log_out
    flash[:danger] = "TODO"
    redirect_to root_url
  end
end
