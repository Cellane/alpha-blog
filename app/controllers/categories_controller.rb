class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.order(:name).paginate(page: params[:page], per_page: 25)
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
    @category_articles = @category.articles.order(id: :desc).paginate(page: params[:page], per_page: 5)
  end

  def update
    if @category.update(category_params)
      flash[:success] = "Category has been updated."
      redirect_to category_path(@category.id)
    else
      render "edit"
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

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
