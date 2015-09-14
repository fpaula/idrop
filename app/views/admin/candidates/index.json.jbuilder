json.array!(@candidates) do |candidate|
  json.extract! candidate, :id, :name, :status, :image_url
  json.url candidate_url(candidate, format: :json)
end
