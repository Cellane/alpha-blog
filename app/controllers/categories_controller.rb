class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.order(:name).paginate(page: params[:page], per_page: 5)
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category has been created."
      redirect_to categories_path
    else
      render "new"
    end
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def show
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? && !current_user.admin?)
      flash[:error] = "Only admins can perform this action."
      redirect_to categories_path
    end
  end
end
