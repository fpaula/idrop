class Candidate < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :vote_summary

  attachment :modified_image

  scope :from_category, ->(category_id) {
    joins(:categories).where(categories: { id: category_id }) if category_id.to_i > 0
  }

  def category
    self.try(:categories).try(:first)
  end
end
