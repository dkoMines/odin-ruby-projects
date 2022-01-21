def shift(char, num, char_to_num, num_to_char)
    do_upcase = (char != char.downcase)
    char = char.downcase
    return char if (char_to_num[char] == nil)
    char_num = char_to_num[char] + num
    char_num = char_num - char_to_num.length if char_num > char_to_num.length
    do_upcase ? num_to_char[char_num].upcase : num_to_char[char_num]
end

def caeser_cypher(string, num)
    i = 0
    char_to_num = Hash.new
    num_to_char = Hash.new
    ('a'..'z').each{ |c| 
        char_to_num[c] = i
        num_to_char[i] = c
        i = i+1
    }    
    return (string.chars.map { |c|
        shift(c, num, char_to_num, num_to_char)
    }.join(""))  
end

puts caeser_cypher("What a string!", 5)
