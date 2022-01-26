require 'json'

class Dictionary
  def initialize
    @dictionary = find_dictionary
  end

  def find_dictionary
    # Download from https://www.scrapmaker.com/data/wordlists/twelve-dicts/5desk.txt
    f_name = '5desk.txt'
    abort('File 5desk.txt does not exist. Make sure to be in the hangman root folder.') unless File.exist?(f_name)
    File.open(f_name, 'r').readlines.map(&:strip).map(&:downcase)
  end

  def select_word
    @dictionary.select { |word| word.length >= 5 && word.length <= 12 }.sample
  end
end

class Game
  SAVE_FILE_NAME = 'saved_game.json'

  def initialize(guesses_left = 6, answer = find_new_word, letters_guessed = [])
    @guesses_left = guesses_left
    @answer = answer
    @letters_guessed = letters_guessed
  end

  def print_word_left
    puts 'Word: '.concat(@answer.split('').map{ |c| @letters_guessed.include?(c) ? c : '_' }.join(' '))
    puts 'Letters Guessed: '.concat(@letters_guessed.join(' '))
  end

  def check_win
    @answer.split('').reduce(true) { |bool, c|
      return false unless bool

      bool && @letters_guessed.include?(c)
    }
  end

  def clear_terminal
    system('clear')
    system('cls')
  end

  def start_game
    clear_terminal
    print_word_left
    while @guesses_left.positive? do
      puts "You have #{@guesses_left} incorrect guess(es) left."
      a = make_guess
      @letters_guessed << a
      clear_terminal
      if @answer.include?(a)
        puts "Correct! #{@answer.count(a)} #{a}'s"
        print_word_left
        break if check_win
      else
        puts 'Incorrect!'
        print_word_left
        @guesses_left -= 1
      end
    end
    puts "You lose! The word was #{@answer}." unless @guesses_left.positive?
    puts 'Congrats, you won!' if check_win
    play_again
  end

  def find_new_word
    Dictionary.new.select_word
  end

  def make_guess
    guess = ''
    loop do
      print 'Guess a letter. Save and quit with "sq!": '
      guess = gets.chomp.downcase
      break if (('a'..'z').include?(guess) && !@letters_guessed.include?(guess)) || guess == 'sq!'
      puts 'Bad input. Please try again!'
    end
    if guess == 'sq!'
      to_json
      exit
    end
    guess
  end

  def to_json(*_args)
    json = JSON.dump({
                       guesses_left: @guesses_left,
                       answer: @answer,
                       letters_guessed: @letters_guessed
                     })
    File.write(Game::SAVE_FILE_NAME, json)
  end

  def self.from_json(string)
    data = JSON.load string
    File.delete(Game::SAVE_FILE_NAME)
    new(data['guesses_left'], data['answer'], data['letters_guessed'])
  end
end

def load_game
  answer = ''
  loop do
    print 'Would you like to load your last saved game? (y/n): '
    answer = gets.chomp.downcase
    break if %w[y n].include?(answer)

    puts 'Incorrect input, try again.'
  end
  if answer == 'y'
    Game.from_json(File.read(Game::SAVE_FILE_NAME))
  else
    Game.new
  end
end

def play_again
  answer = ''
  loop do
    print 'Would you like to play again? (y/n): '
    answer = gets.chomp.downcase
    break if %w[y n].include?(answer)

    puts 'Incorrect input, try again.'
  end
  if answer == 'y'
    game = Game.new
    game.start_game
  else
    exit
  end
end

game = File.exist?(Game::SAVE_FILE_NAME) ? load_game : Game.new
game.start_game
