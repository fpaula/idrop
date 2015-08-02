class ElectionsController < ApplicationController
  def index
    #Election.where(status: true)
  end

  def show
    @election = Election.find(params[:id])
    @total_votes = @election.ranking.reduce(0) { |sum, c| sum + c.total_votes }
  end
end