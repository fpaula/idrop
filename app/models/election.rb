class Election < ActiveRecord::Base
  belongs_to :category
  has_many :vote_summary

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
    ranking.reduce(0) { |sum, c| sum + c.total_votes }
  end
end