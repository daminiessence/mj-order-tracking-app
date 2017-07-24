class UsersController < ApplicationController

  before_action :logged_in_user, only: [ :index, :edit, :update, :destroy ]
  before_action :admin_user, only: :destroy
  before_action :correct_user, only: [ :edit, :update ]

  add_breadcrumb "users", :users_path

  def index
    @users = User.all
  end

  def show
    @user = User.find_by id: params[:id]
    add_breadcrumb "#{@user.first_name.downcase}", user_path(@user)
  end

  def new
    @user = User.new
    add_breadcrumb "signup", signup_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "TODO: Sign up done!"
      redirect_to root_url
    elsif
      flash.now[:danger] = "TODO: Opps, something went wrong with your sign up..."
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "TODO: update success"
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "TODO: update failed"
      render :new
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash.now[:warning] = "User deleted!"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name,
        :email,
        :agent_id,
        :password, :password_confirmation)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
