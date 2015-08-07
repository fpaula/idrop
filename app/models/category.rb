class Category < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  validate :valid_parent, on: :update

  belongs_to :parent, class_name: "Category", foreign_key: "parent_id"
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  has_and_belongs_to_many :candidates
  has_many :elections
  has_many :vote_summary

  def has_parent?
    @has_parent ||= !self.parent.nil?
  end

  def image_url
    self.try(:candidates).try(:first).try(:image_url)
  end

  def valid_parent
    if self.id == self.parent_id
      errors.add(:parent, "can't be itself")
    end
  end
end