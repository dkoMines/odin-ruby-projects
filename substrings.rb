def substrings(phrase, dict)
  phrase = phrase.downcase
  dict.each_with_object(Hash.new(0)) do |substring, count_hash|
    count_hash[substring] = phrase.scan(substring).length if phrase.scan(substring).length > 0
  end
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]
puts substrings('below', dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
