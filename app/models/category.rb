class Category < ActiveRecord::Base
  belongs_to :parent, class_name: "Category", foreign_key: "parent_id"
  has_many :children, class_name: "Category", foreign_key: "parent_id"

  def has_parent?
    @has_parent ||= !self.parent.nil?
  end
end
