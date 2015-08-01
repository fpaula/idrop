class HomeController < ApplicationController
  def index
    @carousel = Category.last(3)
    @highlights = Category.offset(3).last(6)
  end
end