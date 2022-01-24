class Player
  attr_reader :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def make_move
    loop do
      puts 'Select a square (ex a1): '
      answer = gets.chomp
      char_to_num = { 'a' => 0, 'b' => 1, 'c' => 2 }
      if ('a'..'c').include?(answer[0].downcase) && ('1'..'3').include?(answer[1])
        return [char_to_num[answer[0]].to_i, (answer[1].to_i - 1)]
      else
        puts 'Illegal input. Please try again!'
      end
    end
  end
end

class Bot < Player
  def initialize
    super('bot', 'O')
  end

  def make_move
    [rand(3), rand(3)]
  end
end

class Game
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Array.new(3) { Array.new(3, '-') }
    @score = [0, 0]
  end

  def check_winner(symbol)
    # Check Rows
    @board.each do |row|
      return true if row.all?(symbol)
    end

    # Check Diagonals
    return true if [@board[0][0], @board[1][1], @board[2][2]].all?(symbol)
    return true if [@board[2][0], @board[1][1], @board[0][2]].all?(symbol)

    # Check Columns
    @board.each_index do |i|
      return true if [@board[0][i], @board[1][i], @board[2][i]].all?(symbol)
    end
    false
  end

  def play_game
    @board = Array.new(3) { Array.new(3, '-') }
    winner = 0
    loop do
      print_board
      player_turn(@player1)
      if check_winner(@player1.symbol)
        winner = 1
        break
      end
      break unless @board.flatten.include?('-')

      player_turn(@player2)
      if check_winner(@player2.symbol)
        winner = 2
        break
      end
      break unless @board.flatten.include?('-')
    end

    print_board
    if winner.zero?
      puts 'Tie Game!'
    else
      puts "Player #{winner} Wins!"
      @score[winner - 1] += 1
    end
  end

  def player_turn(player)
    loop do
      move = player.make_move
      if @board[move[0]][move[1]] == '-'
        @board[move[0]][move[1]] = player.symbol
        break
      end
    end
  end

  def print_board
    system 'clear'
    puts format("
    1   2   3
      |   |
a   %c | %c | %c
  ____|___|___
      |   |
b   %c | %c | %c
  ____|___|___
      |   |
c   %c | %c | %c
      |   |
    ", @board[0][0], @board[0][1], @board[0][2], @board[1][0], @board[1][1], @board[1][2], @board[2][0], @board[2][1], @board[2][2])
  end
end

p1 = Player.new('Player1', 'X')
p2 = Bot.new
game = Game.new(p1, p2)
game.play_game
