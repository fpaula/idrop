class CandidateCombination < ActiveRecord::Base
  belongs_to :election
  belongs_to :candidate_1, class_name: 'Candidate', foreign_key: 'candidate_id_1'
  belongs_to :candidate_2, class_name: 'Candidate', foreign_key: 'candidate_id_2'

  def has_candidate?(candidate_id)
    [self.candidate_id_1, self.candidate_id_2].include?(candidate_id.to_i)
  end
end