class Election < ActiveRecord::Base
  extend FriendlyId

  belongs_to :category
  has_many :vote_summary
  has_many :candidate_combinations
  friendly_id :slug_candidates, use: :slugged

  after_create :update_slug

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

  def combinations
    @combinations ||= begin
      Rails.cache.fetch("election_combinations_#{id}", expires_in: 24.hours) do
        candidate_combinations
      end
    end
  end

  private

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
end