class Election < ActiveRecord::Base
  belongs_to :category

  def candidates
    self.category.candidates
  end
end