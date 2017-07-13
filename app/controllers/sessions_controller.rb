class SessionsController < ApplicationController

  def new
  end

  def create
    if (user = User.find_by(email: params[:session][:email]))
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      flash[:success] = "TODO: login ok"
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
