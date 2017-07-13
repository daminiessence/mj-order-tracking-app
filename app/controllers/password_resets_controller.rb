class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email
      flash[:success] = "TODO: Pass. reset create successfull"
      redirect_to root_url
    else
      flash.now[:danger] = "TODO: Pass. reset create failed"
      render :new
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    if @user && BCrypt::Password.new(@user.password_reset_digest)
      .is_password?(params[:id])
    else
      redirect_to root_url
    end
  end

  def update
    @user = User.find_by(email: params[:email])
    if @user && BCrypt::Password.new(@user.password_reset_digest)
      .is_password?(params[:id])
      @user.update_attributes(password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation])
      log_in @user
      flash[:success] = "TODO: Password reset successful"
      redirect_to user_path(@user.id)
    else
      redirect_to root_url
    end
  end
end
