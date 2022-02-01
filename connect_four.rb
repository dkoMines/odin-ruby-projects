class Player
  attr_accessor :symbol, :win_msg

  def initialize(symbol, win_msg)
    @symbol = symbol
    @win_msg = win_msg
  end

  def place_piece
    selection = ''
    until ('1'..'7').include?(selection)
      puts 'Select a column to place your piece (1-7): '
      selection = gets.chomp
      puts 'Incorrect input. Please try again.' unless ('1'..'7').include?(selection)
    end
    selection.to_i - 1
  end
end

class Bot < Player
  def place_piece
    rand(7)
  end
end

class Game
  attr_accessor :board

  def initialize
    @board = Array.new(6) { Array.new(7, '_') }
    pickaxe = "\u26C1"
    snowman = "\u26C3"
    @player1 = Player.new(pickaxe.encode('utf-8'), 'You WIN!!!')
    @player2 = Bot.new(snowman.encode('utf-8'), 'Bot Player Wins. Better luck next time!')
  end

  def play_game
    loop do
      print_board
      place(@player1)
      break unless check_win.nil?

      place(@player2)
      break unless check_win.nil?
    end
    print_board
    puts check_win
  end

  def place(player)
    piece_placed = false
    until piece_placed
      col = player.place_piece.to_i
      if @board.first[col] == '_'
        row_num = 0
        until row_num >= @board.length
          if row_num == @board.length - 1 || @board[row_num + 1][col] != '_'
            @board[row_num][col] = player.symbol
            piece_placed = true
            break
          end
          row_num += 1
        end
      elsif player.instance_of?(Player)
        puts 'This column is full. Please try a different one.'
      end
    end
  end

  def check_win
    [@player1, @player2].each do |player|
      # Check Rows
      @board.each do |row|
        c = 0
        row.each do |piece|
          if piece == player.symbol
            c += 1
          else
            c = 0
          end
          return player.win_msg if c == 4
        end
      end
      # Check Cols
      (0...@board[0].length).each do |col_num|
        c = 0
        @board.each do |row|
          piece = row[col_num]
          if piece == player.symbol
            c += 1
          else
            c = 0
          end
          return player.win_msg if c == 4
        end
      end
      # Check Diags
      (0..@board.length - 4).each do |row_num|
        (3..@board[0].length - 4).each do |col_num| # Down Left
          count = 0
          (0..3).each do |add_num|
            count += 1 if @board[row_num + add_num][col_num - add_num] == player.symbol
          end
          return player.win_msg if count == 4
        end
        (3..@board[0].length - 4).each do |col_num| # Down Right
          count = 0
          (0..3).each do |add_num|
            count += 1 if @board[row_num + add_num][col_num + add_num] == player.symbol
          end
          return player.win_msg if count == 4
        end
      end
    end

    # Tie game
    return 'Tie Game' if @board.all? { |row| row.all? { |p| p != '_' } }

    nil
  end

  def print_board
    system('clear')
    system('cls')
    @board.each do |row|
      print '| '
      print row.join(' ')
      puts ' |'
    end
    print '| '
    ('1'..'7').each { |num| print num.concat ' ' }
    puts '|'
  end
end

game = Game.new
game.play_game
