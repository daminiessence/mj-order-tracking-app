class AccountActivationsController < ApplicationController

  def edit
    token = params[:id]
    email = params[:email]
    user = User.find_by(email: email)
    if user && user.authenticate_token(:activation_token, token)
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "TODO: Acc. activation"
      redirect_to user_path(user)
    else
      flash[:danger] = "TODO: wrong email / token"
      redirect_to root_url
    end
  end
end
