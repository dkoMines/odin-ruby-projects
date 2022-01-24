class Player
  def create_input; end
end

class HumanPlayer < Player
  def create_input(range, status)
    puts status == :code_maker ? 'Create a code to break!' : 'Guess the code!'
    board = []
    loop do
      puts "Enter 4 digits between 0 and #{range}: "
      board = gets.chomp.split('')
      break if board.length == 4 && board.all? { |c| c.match?(/[[:digit:]]/) }

      puts 'Incorrect input, try again!'
    end
    board.map { |num| num.to_i }
  end
end

class RobotPlayer < Player
  def create_input(range, _)
    board = []
    4.times do
      board << rand(range)
    end
    board
  end
end

class Board
  def initialize(pegs)
    @pegs = pegs
  end

  def check_guess(guess)
    guess = guess.clone
    answer = @pegs.clone
    black_pegs = 0 # indicates correct color and placement
    white_pegs = 0 # indicates correct color, but wrong placement
    guess.each_with_index do |color, index|
      next unless color == answer[index]

      guess[index] = 'X'
      answer[index] = 'Y'
      black_pegs += 1
    end
    guess.each do |color|
      unless answer.find_index(color).nil?
        answer[answer.find_index(color)] = 'Y'
        white_pegs += 1
      end
    end
    [black_pegs, white_pegs]
  end
end

class Game
  def initialize(range)
    answer = 1
    loop do
      puts "Enter (1/2): \n1. You are the code breaker \n2. You are the code maker"
      answer = gets.chomp.to_i
      break if [1, 2].include?(answer)

      puts 'Incorrect input, try again!'
    end
    if answer == 1
      @code_breaker = HumanPlayer.new
      @code_maker = RobotPlayer.new
    else
      @code_breaker = RobotPlayer.new
      @code_maker = HumanPlayer.new
    end
    @board = Board.new(@code_maker.create_input(range, :code_maker))
    @guesses = 12
    @range = range
  end

  def print_guess(guess, bw_pegs)
    str = "Guess: #{guess} Pegs: "
    bw_pegs[0].times do
      str += "\u25CB".encode('utf-8')
    end
    bw_pegs[1].times do
      str += "\u25CF".encode('utf-8')
    end
    puts str
  end

  def play_game
    print_instructions
    while @guesses >= 0
      puts "Guesses Left: #{@guesses}"
      guess = @code_breaker.create_input(@range, :code_breaker)
      pegs = @board.check_guess(guess)
      print_guess(guess, pegs)
      if pegs[0] == 4
        puts 'Code Breaker Wins!'
        break
      end
      @guesses -= 1
    end
    puts 'Code Maker Wins!' if @guesses.negative?
  end

  def print_instructions
    filled_in_circle = "\u25CB".encode('utf-8')
    hollow_circle =  "\u25CF".encode('utf-8')
    puts "#{filled_in_circle} means correct guess and position. #{hollow_circle}  means correct guess but wrong position."
  end
end

game = Game.new(9)
game.play_game
