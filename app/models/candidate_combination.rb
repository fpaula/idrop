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
    combination = random_combination(election, user_combinations.list)
    combination ? combination.to_json(include: [:candidate_1, :candidate_2]) : nil
  end

  # Public: create entries in the table candidate_combinations with all combinations
  # of candidates, without repetition. Be aware that, for the sake of this algorithm,
  # [1, 2] is the same as [2, 1] and, thus, one combination will not enter the list.
  #
  # Returns: list of combinations
  def self.combine(election)
    size = election.candidates.length
    result = []

    0.upto(size - 2).each do |i|
      (i + 1).upto(size - 1).each do |j|
        combination = CandidateCombination.create(election_id: election.id,
          candidate_1: election.candidates[i], candidate_2: election.candidates[j])

        result << [combination.candidate_1.id, combination.candidate_2.id]
      end
    end

    result
  end

  def self.random_combination(election, exception_list = [])
    # Remove from the array of ids those that were already used
    ids = election.combinations.map(&:id) - exception_list

    if ids.length > 0
      # Picks a randon position in the list of valid id's
      index = rand(0..ids.length - 1)

      # Gets the id of the combination
      id = ids[index]

      # Returns the combination from the random index.
      # If there are no entries in the database (for example, if a new candidate is created and
      # the process deleted all combinations, but didn't create new ones yet), the election
      # will end prematurely
      election.combinations.find_by(id: id)
    else
      nil
    end
  end

  def self.recombine_candidates(category)
    category.active_elections.each do |election|
      CandidateCombination.delete_all(election_id: election.id)
      combine(election)
    end
  end
end