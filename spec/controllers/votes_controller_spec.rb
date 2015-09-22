require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:category) { FactoryGirl.create(:category, id: 1, name: 'Animes') }
  let(:election) { FactoryGirl.create(:election, id: 1, category: category, title: 'Qual o melhor anime?') }
  let(:user_combinations) { UserCombinations.new(controller.send(:session_key)) }

  describe 'POST create' do
    let(:inuyasha) { FactoryGirl.create(:candidate, id: 1, name: 'Inuyasha') }
    let(:onepiece) { FactoryGirl.create(:candidate, id: 2, name: 'One Piece') }
    let(:yuyuhakusho) { FactoryGirl.create(:candidate, id: 3, name: 'Yuyu Hakusho') }
    let(:combination) { FactoryGirl.create(:candidate_combination, id: 1, election: election, candidate_1: inuyasha, candidate_2: onepiece) }

    before do
      user_combinations.clear
      Rails.cache.delete("election_combinations_#{election.id}")
    end

    it 'returns a bad request when the election is invalid' do
      post :create, vote: { election_id: 10, candidate_combination_id: combination.id }

      expect(response.status).to eq(400)
    end

    it 'returns a bad request when the combination is invalid' do
      post :create, vote: { election_id: election.id, candidate_combination_id: 10 }

      expect(response.status).to eq(400)
    end

    it 'returns null when the election is over' do
      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id }

      expect(response.body).to eq('null')
    end

    it 'returns the next combination' do
      new_combination = FactoryGirl.create(:candidate_combination, id: 2, election: election, candidate_1: yuyuhakusho, candidate_2: onepiece)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id }

      expect(JSON.parse(response.body)['id']).to eq(new_combination.id)
    end

    it 'persists the vote and save the combination' do
      expect(Vote.count).to eq(0)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: inuyasha }

      expect(user_combinations.list).to eq([combination.id])
      expect(Vote.count).to eq(1)

      vote = Vote.last
      expect(vote.election_id).to eq(election.id)
      expect(vote.candidate_id).to eq(inuyasha.id)
    end

    it 'includes a new combination_id to a user\'s combination list ' do
      new_combination = FactoryGirl.create(:candidate_combination, id: 2, election: election, candidate_1: yuyuhakusho, candidate_2: onepiece)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: onepiece.id }
      expect(user_combinations.list).to eq([combination.id])

      post :create, vote: { election_id: election.id, candidate_combination_id: new_combination.id, candidate_id: yuyuhakusho.id }
      expect(user_combinations.list).to eq([combination.id, new_combination.id])
    end

    it 'creates a new vote summary' do
      expect(VoteSummary.count).to eq(0)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: inuyasha }

      vote_summary = VoteSummary.last
      expect(vote_summary.election_id).to eq(election.id)
      expect(vote_summary.candidate_id).to eq(inuyasha.id)
      expect(vote_summary.total_votes).to eq(1)
    end

    it 'updates a vote summary' do
      expect(VoteSummary.count).to eq(0)
      vote_summary = FactoryGirl.create(:vote_summary, election_id: election.id, candidate_id: inuyasha.id)
      expect(VoteSummary.count).to eq(1)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: inuyasha }

      vote_summary = VoteSummary.last
      expect(vote_summary.election_id).to eq(election.id)
      expect(vote_summary.candidate_id).to eq(inuyasha.id)
      expect(vote_summary.total_votes).to eq(2)
    end

    it 'prevents a user to vote twice in the same combination' do
      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: inuyasha }
      expect(user_combinations.list).to eq([combination.id])
      expect(VoteSummary.last.total_votes).to eq(1)

      post :create, vote: { election_id: election.id, candidate_combination_id: combination.id, candidate_id: inuyasha }
      expect(user_combinations.list).to eq([combination.id])
      expect(VoteSummary.last.total_votes).to eq(1)
    end
  end
end