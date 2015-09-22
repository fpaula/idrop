class ElectionsController < ApplicationController
  def index
    #Election.where(status: true)
  end

  def show
    @election = Election.friendly.find(params[:id])
    @user_combinations = UserCombinations.new(session_key)
  end
end