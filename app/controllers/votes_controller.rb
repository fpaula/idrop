class VotesController < ApplicationController

  def index
  end

  def create
    #TODO: O codigo abaixo ainda não funciona porque depende de models que ainda nao existem
    election = Election.find_by_id(params[:vote][:election_id])
    candidate = Candidate.find_by_id(params[:vote][:candidate_id])

    if election && candidate
      vote = Vote.create(vote_params)
      vote_summary = VoteSummary.find_by(election_id: election.id, candidate_id: candidate.id)
      if vote_summary
        vote_summary.increment!
        vote_summary.save
      end
      render json: {success: true}
    else
      render json: {success: false}, status: :bad_request
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:election_id, :candidate_id, :user_id)
  end
end