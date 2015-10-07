module ApplicationHelper
  def nested_category(id)
    text = ''
    category = Category.find_by_id(id)
    if !category.parent_id
      text = category.name
    else
      text = "#{nested_category(category.parent_id)} > #{category.name}"
    end
    text
  end

  def nested_categories(categories)
    result = []
    categories.each do |category|
      result << [nested_category(category.id), category.id]
    end
    result
  end

  def humanize_votes(votes = 0)
    votes = 0 if votes.nil?
    number_with_delimiter(votes, delimiter: '.') + (votes == 1 ? ' voto': ' votos')
  end
end