class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Sign up done!"
      redirect_to root_url
    elsif
      flash.now[:danger] = "Opps, something went wrong with your sign up..."
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
    User.find(params[:id]).destroy
    flash.now[:warning] = "User deleted!"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
