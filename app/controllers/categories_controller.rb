class CategoriesController < ApplicationController
  def show
  end

  def index
    @categories = Category.order(:name)
  end
end
