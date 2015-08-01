class Candidate < ActiveRecord::Base
  has_and_belongs_to_many :categories

  def category
    self.try(:categories).try(:first)
  end
end
