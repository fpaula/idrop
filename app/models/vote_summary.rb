class VoteSummary < ActiveRecord::Base

  def increment!
    self.total_votes += 1
  end
end
