class HomeController < ApplicationController
  def index
    @carousel = Election.last(3)
    @highlights = Election.offset(3).last(6)
  end
end