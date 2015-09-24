class ElectionsController < ApplicationController
  def index
    #Election.where(status: true)
  end

  def show
    @election = Election.friendly.find(params[:id])
    @user_combinations = UserCombinations.new(session_key)
  end

  def combination
    election = Election.friendly.find(params[:id])
    combination = CandidateCombination.random_combination(election, UserCombinations.new(session_key).list)
    render json: combination
  end
end