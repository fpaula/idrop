class Election < ActiveRecord::Base
  extend FriendlyId

  belongs_to :category
  has_many :vote_summary
  friendly_id :slug_candidates, use: :slugged

  after_create :update_slug

  def candidates
    @candidates ||= self.category.candidates
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
    self.candidates.try(:first).try(:image_url)
  end

  # If the slug exist, we include the id at the end of the url. This is
  # because the url of an election will be repeated over and over again.
  # The default behavior of the friendly_id is to insert a sha1 code into
  # the url. We have to update after creating because during the creation
  # the id is still not available
  def update_slug
    self.update_attributes(slug: nil)
    self.save!
  end

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end
end