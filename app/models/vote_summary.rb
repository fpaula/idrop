class VoteSummary < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :election

  def increment!
    self.total_votes += 1
  end
end
