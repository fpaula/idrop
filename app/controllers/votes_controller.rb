class VotesController < ApplicationController

  def index
  end

  def create
    #TODO: O codigo abaixo ainda não funciona porque depende de models que ainda nao existem
    election = Election.find(params[:vote][:election_id])
    candidate = Candidate.find(params[:vote][:candidate_id])
    if election && candidate
      vote = Vote.save(params[:vote])
      vote_summary = VoteSummary.find_by(election_id: election.id, candidate_id: candidate.id)
      if vote_summary
        vote_summary.increment!
        vote_summary.save
      end
    else
      render status: :bad_request
    end
  end
end