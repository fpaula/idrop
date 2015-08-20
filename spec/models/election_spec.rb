require 'rails_helper'

describe Election do
  let(:category) { FactoryGirl.create(:category, id: 1, name: 'Portugueses') }
  let(:election) { FactoryGirl.create(:election, id: 1, category: category, title: 'Os melhores nomes porgueses') }

  describe '#combine_candidates' do
    let(:joaquim) { FactoryGirl.create(:candidate, id: 1, name: 'Joaquim') }
    let(:manuel) { FactoryGirl.create(:candidate, id: 2, name: 'Manuel') }
    let(:francisco) { FactoryGirl.create(:candidate, id: 3, name: 'Francisco') }

    it 'combines all candidates without repetition' do
      expected_result = [
        [joaquim.id, manuel.id],
        [joaquim.id, francisco.id],
        [manuel.id, francisco.id]
      ]

      allow(election).to receive(:candidates) { [joaquim, manuel, francisco] }
      expect(election.combine_candidates).to eq(expected_result)
    end
  end
end