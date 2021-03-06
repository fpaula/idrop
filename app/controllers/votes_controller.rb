class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    election = Election.find_by_id(params[:vote][:election_id])
    combination = CandidateCombination.find_by_id(params[:vote][:candidate_combination_id])

    if election && combination
      candidate_id = params[:vote][:candidate_id]

      candidate = Candidate.find_by_id(candidate_id) if candidate_id

      if valid?(user_combinations, combination, candidate)
        vote(election, candidate, Vote.create(vote_params))
      end

      user_combinations.save(combination.id, candidate_id)

      next_combination = CandidateCombination.next(election, user_combinations)

      render json: next_combination
    else
      render json: { success: false }, status: :bad_request
    end
  end

  private

  def user_combinations
    @user_combinations ||= UserCombinations.new(session_key)
  end

  def valid?(user_combinations, combination, candidate)
    candidate.present? && combination.has_candidate?(candidate.id) && !user_combinations.include?(combination.id)
  end

  def vote_params
    params.require(:vote).permit(:election_id, :candidate_id, :user_id)
  end

  def vote(election, candidate, vote)
    vote_summary = VoteSummary.find_by(election_id: election.id, candidate_id: candidate.id)

    if vote_summary
      vote_summary.increment!
      vote_summary.save
    else
      VoteSummary.create(election_id: election.id, candidate_id: candidate.id, total_votes: 1)
    end
  end
end