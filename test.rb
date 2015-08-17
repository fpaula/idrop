def combine_candidates(candidates)
  size = candidates.length

  list = []
  0.upto(size - 2).each do |i|
    (i + 1).upto(size - 1).each do |j|
      list << [candidates[i], candidates[j]]
    end
  end
  list
end


candidates = (1..30).to_a

#expected_result = [[1, 2], [1, 3], [2, 3]]

result = combine_candidates(candidates)
puts result.length

#puts result == expected_result

