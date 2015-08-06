class ElectionsController < ApplicationController
  def index
    #Election.where(status: true)
  end

  def show
    @election = Election.friendly.find(params[:id])
  end
end