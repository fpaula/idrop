class Election < ActiveRecord::Base
  extend FriendlyId

  belongs_to :category
  has_many :vote_summary
  has_many :candidate_combinations
  friendly_id :slug_candidates, use: :slugged

  after_create :update_slug, :combine_candidates

  # TODO return true if the election is running
  def active?
    true
  end

  # TODO call this method to close an election
  # It will also clean the combinations table
  def self.close(election_id)
    CandidateCombination.delete_all(election_id: election_id)
  end

  def candidates
    @candidates ||= begin
      Rails.cache.fetch("candidates_for_election_#{id}") do
        category.candidates
      end
    end
  end

  def ranking
    @ranking ||= begin
      candidates.joins(:vote_summary)
        .order('vote_summaries.total_votes desc')
        .select('candidates.*, vote_summaries.total_votes')
    end
  end

  def total_votes
    @total_votes ||= ranking.reduce(0) { |sum, c| sum + c.total_votes }
  end

  def top(count)
    ranking.take(count)
  end

  def image_url
    candidates.try(:first).try(:image_url)
  end

  # If the slug exist, we include the id at the end of the url. This is
  # because the url of an election will be repeated over and over again.
  # The default behavior of the friendly_id is to insert a sha1 code into
  # the url. We have to update after creating because during the creation
  # the id is still not available
  def update_slug
    update_attributes(slug: nil)
    save!
  end

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def combinations
    @combinations ||= begin
      Rails.cache.fetch("election_combinations_#{id}", expires_in: 24.hours) do
        candidate_combinations
      end
    end
  end

  def random_combination(exception_list = [])
    # Remove from the array of ids those that were already used
    ids = combinations.map(&:id) - exception_list

    if ids.length > 0
      # Picks a randon position in the list of valid id's
      index = rand(0..ids.length - 1)

      # Gets the id of the combination
      id = ids[index]

      # Returns the combination from the random index.
      # If there are no entries in the database (for example, if a new candidate is created and
      # the process deleted all combinations, but didn't create new ones yet), the election
      # will end prematurely
      combinations.find_by(id: id)
    else
      nil
    end
  end

  # Public: create entries in the table candidate_combinations with all combinations
  # of candidates, without repetition. Be aware that, for the sake of this algorithm,
  # [1, 2] is the same as [2, 1] and, thus, one combination will not enter the list.
  #
  # Returns: list of combinations
  def combine_candidates
    size = candidates.length
    result = []

    0.upto(size - 2).each do |i|
      (i + 1).upto(size - 1).each do |j|
        combination = CandidateCombination.create(election_id: id,
          candidate_1: candidates[i], candidate_2: candidates[j])

        result << [combination.candidate_1.id, combination.candidate_2.id]
      end
    end

    result
  end
end