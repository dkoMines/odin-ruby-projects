def shift(char, num, char_to_num, num_to_char)
  do_upcase = (char != char.downcase)
  char = char.downcase
  return char if char_to_num[char].nil?

  char_num = char_to_num[char] + num
  char_num -= char_to_num.length if char_num > char_to_num.length
  do_upcase ? num_to_char[char_num].upcase : num_to_char[char_num]
end

def caeser_cypher(string, num)
  i = 0
  char_to_num = {}
  num_to_char = {}
  ('a'..'z').each  do |c|
    char_to_num[c] = i
    num_to_char[i] = c
    i += 1
  end
  string.chars.map do |c|
    shift(c, num, char_to_num, num_to_char)
  end.join('')
end

puts caeser_cypher('What a string!', 5)
