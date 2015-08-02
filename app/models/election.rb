class Election < ActiveRecord::Base
  belongs_to :category
  has_many :vote_summary

  attr_accessor :total_votes

  def candidates
    @candidates ||= self.category.candidates
  end

  def ranking
    @ranking ||=
      self.candidates.joins(:vote_summary)
          .order('vote_summaries.total_votes desc')
          .select('candidates.*, vote_summaries.total_votes')
  end
end