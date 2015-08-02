class Candidate < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :vote_summary

  def category
    self.try(:categories).try(:first)
  end
end
