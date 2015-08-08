json.array!(@elections) do |election|
  json.extract! election, :id, :title, :category_id, :status
  json.url election_url(election, format: :json)
end
