json.array!(@categories) do |category|
  json.extract! category, :id, :name, :parent_id, :status
  json.url category_url(category, format: :json)
end
