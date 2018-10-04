class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 8)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome to the Alpha Blog!"
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
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
    @articles = @user.articles.order(id: :desc).paginate(page: params[:page], per_page: 3)
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully."
      redirect_to articles_path
    else
      render "edit"
    end
  end

  def destroy
    if @user == current_user
      session[:user_id] = nil
    end

    @user.destroy
    flash[:danger] = "User and all user’s articles have been deleted."
    redirect_to users_path
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:error] = "You can only edit your own account."
      redirect_to users_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = "Only admin users can perform that action."
      redirect_to users_path
    end
  end
end
