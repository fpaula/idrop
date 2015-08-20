# This class abstracts the relationship between a user and the candidate
# combinations. It is responsible to store in memory (or redis) the list
# of combinations voted or skipped, to prevent repetitions and to
# protect an election from hacking attempts
class UserCombinations
  attr_accessor :session_key

  def initialize(session_key)
    self.session_key = session_key
  end

  def save(candidate_combination_id, candidate_id = nil)
    if combination = CandidateCombination.find_by_id(candidate_combination_id)
      if candidate_id.nil? || combination.has_candidate?(candidate_id)
        list << candidate_combination_id unless list.include?(candidate_combination_id)

        Rails.cache.write(session_key, list)
      end
    end
  end

  def clear
    Rails.cache.write(session_key, [])
  end

  def include?(candidate_combination_id)
    list.include?(candidate_combination_id)
  end

  def list
    @list ||= begin
      Rails.cache.read(session_key) || []
    end
  end
end