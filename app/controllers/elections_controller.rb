class ElectionsController < ApplicationController
  def index
    #Election.where(status: true)
  end

  def show
    @election = Election.find(params[:id])

    if request.xhr?
      render partial: 'elections/election', locals: { election: @election }
    end
  end
end