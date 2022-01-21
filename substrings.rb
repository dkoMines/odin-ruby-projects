
def substrings(phrase, dict)
    phrase = phrase.downcase
    dict.reduce(Hash.new(0)) do |count_hash, substring| 
        count_hash[substring] = phrase.scan(substring).length if phrase.scan(substring).length > 0
        count_hash
    end
end



dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts substrings("below", dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)