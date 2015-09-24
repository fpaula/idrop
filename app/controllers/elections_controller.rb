class ElectionsController < ApplicationController
  def show
    @election = Election.friendly.find(params[:id])
    @user_combinations = UserCombinations.new(session_key)
    @combination = CandidateCombination.random_combination(@election, UserCombinations.new(session_key).list)
  end
end