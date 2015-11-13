class CategoriesController < ApplicationController
  def show
  end

  def index
    @categories = Category.with_elections.order(:name)
  end
end
