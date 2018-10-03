class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome to the Alpha Blog!"
      redirect_to articles_path
    else
      render "new"
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully."
      redirect_to articles_path
    else
      render "edit"
    end
  end

  private


  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
