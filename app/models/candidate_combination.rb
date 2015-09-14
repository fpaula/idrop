class CandidateCombination < ActiveRecord::Base
  belongs_to :election
  belongs_to :candidate_1, class_name: 'Candidate', foreign_key: 'candidate_id_1'
  belongs_to :candidate_2, class_name: 'Candidate', foreign_key: 'candidate_id_2'

  def has_candidate?(candidate_id)
    [self.candidate_id_1, self.candidate_id_2].include?(candidate_id.to_i)
  end

  # Public: returns the next combination for the given election, excluding the
  # combinations the user already received (it does not matter if the user voted or
  # skipped, the combination will not be provided again once it was rendered and
  # acted upon)
  #
  # To instantiate the user_combinations in a controller that inherits from
  # ApplicationController, do:
  #
  # `user_combinations = UserCombinations.new(session_key)`
  #
  # Where `session_key` is a protected method from the ApplicationController
  def self.next(election, user_combinations)
    combination = election.random_combination(user_combinations.list) || []
    combination.to_json(include: [:candidate_1, :candidate_2])
  end
end