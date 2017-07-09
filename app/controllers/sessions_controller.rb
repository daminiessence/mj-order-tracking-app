class SessionsController < ApplicationController
  def new
  end

  def create
    if (user = User.find_by(email: params[:session][:email]))
      log_in user
      flash[:success] = "TODO: login ok"
      redirect_to root_url
    else
      flash.now[:danger] = "TODO: login not ok"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
