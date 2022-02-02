# lib/chess.rb

class Player
  attr_accessor :color, :name, :graveyard

  def initialize(color, name)
    @color = color
    @name = name
    @graveyard = []
  end

  def add_graveyard(piece)
    @graveyard << piece
  end

  def make_selection(message)
    loop do
      puts message
      answer = gets.chomp.downcase
      return answer if answer == 'quit'

      if ('a'..'h').include?(answer[0]) && ('1'..'8').include?(answer[1]) && answer.length == 2
        char_to_num = {}
        ('a'..'h').each_with_index { |letter, index|
          char_to_num[letter] = index
        }
        return [(8 - answer[1].to_i).to_i, char_to_num[answer[0]].to_i]
      end
    end
  end

  def pick_piece(board)
    loop do
      selection = make_selection('Please select a piece (ex a1): ')
      exit if selection == 'quit'
      piece = board[selection[0]][selection[1]]
      return piece unless piece.nil? || piece.color != @color

      puts 'Not a valid piece. Please try again'
    end
  end

  def pick_target(board, possible_moves)
    loop do
      selection = make_selection('Please where to move (ex a1): ')
      exit if selection == 'quit'
      move = [selection[0], selection[1]]
      p possible_moves
      p move
      return move if possible_moves.include?(move)

      puts 'Not a valid move. Please try again'
    end
  end
end

class Piece
  attr_reader :symbol, :color, :name
  attr_accessor :location

  def can_move(row, col, board)
    in_board(row, col) && (board[row][col].nil? || board[row][col].color != @color)
  end

  def in_board(row, col)
    row >= 0 && row <= 7 && col >= 0 && col <= 7
  end

  def enemy_color(row, col, board)
    board[row][col].instance_of?(Piece) && board[row][col].color != @color
  end

  def get_symbol
    if @color == 'white'
      case @name
      when 'king'
        "\u2654".encode('utf-8')
      when 'queen'
        "\u2655".encode('utf-8')
      when 'rook'
        "\u2656".encode('utf-8')
      when 'bishop'
        "\u2657".encode('utf-8')
      when 'knight'
        "\u2658".encode('utf-8')
      when 'pawn'
        "\u2659".encode('utf-8')
      end
    elsif @color == 'black'
      case @name
      when 'king'
        "\u265A".encode('utf-8')
      when 'queen'
        "\u265B".encode('utf-8')
      when 'rook'
        "\u265C".encode('utf-8')
      when 'bishop'
        "\u265D".encode('utf-8')
      when 'knight'
        "\u265E".encode('utf-8')
      when 'pawn'
        "\u265F".encode('utf-8')
      end
    end
  end

  def to_s
    symbol
  end

  def initialize(name, color, location)
    @name = name
    @color = color
    @location = location
    @symbol = get_symbol
  end

  def possible_moves(board)
    # TODO:: enpassante or castle
    moves = []
    case @name
    when 'king'
      [-1, 0, 1].each { |num1|
        [-1, 0, 1].each { |num2|
          row = @location[0] + num1
          col = @location[1] + num2
          moves << [row, col] unless (num1 == 0 && num2 == 0) || !can_move(row, col, board)
        }
      }
      return moves
    when 'queen'
      up = true
      down = true
      left = true
      right = true
      up_right = true
      down_right = true
      up_left = true
      down_left = true
      (1...8).each { |num1|
        # up
        if up
          row = @location[0] - num1
          col = @location[1]
          moves << [row, col] if can_move(row, col, board)
          up = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down
        if down
          row = @location[0] + num1
          col = @location[1]
          moves << [row, col] if can_move(row, col, board)
          down = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # left
        if left
          row = @location[0]
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # right
        if right
          row = @location[0]
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # up_right
        if up_right
          row = @location[0] - num1
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          up_right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down_right
        if down_right
          row = @location[0] + num1
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          down_right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # up_left
        if up_left
          row = @location[0] - num1
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          up_left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down_left
        if down_left
          row = @location[0] + num1
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          down_left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
      }
      return moves
    when 'rook'
      up = true
      down = true
      left = true
      right = true

      (1...8).each { |num1|
        # up
        if up
          row = @location[0] - num1
          col = @location[1]
          moves << [row, col] if can_move(row, col, board)
          up = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down
        if down
          row = @location[0] + num1
          col = @location[1]
          moves << [row, col] if can_move(row, col, board)
          down = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # left
        if left
          row = @location[0]
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # right
        if right
          row = @location[0]
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
      }
      return moves
    when 'bishop'
      up_right = true
      down_right = true
      up_left = true
      down_left = true

      (1...8).each { |num1|
        # up_right
        if up_right
          row = @location[0] - num1
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          up_right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down_right
        if down_right
          row = @location[0] + num1
          col = @location[1] + num1
          moves << [row, col] if can_move(row, col, board)
          down_right = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # up_left
        if up_left
          row = @location[0] - num1
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          up_left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
        # down_left
        if down_left
          row = @location[0] + num1
          col = @location[1] - num1
          moves << [row, col] if can_move(row, col, board)
          down_left = false if !can_move(row, col, board) || enemy_color(row, col, board)
        end
      }
      return moves
    when 'knight'
      [-2, 2].each { |twos|
        [-1, 1].each { |ones|
          row = location[0] + twos
          col = location[1] + ones
          moves << [row, col] if can_move(row, col, board)
          row = location[0] + ones
          col = location[1] + twos
          moves << [row, col] if can_move(row, col, board)
        }
      }
      return moves
    when 'pawn'
      row = location[0]
      col = location[1]
      if @color == 'white'
        mult = 1
        start_row = 6
      elsif @color == 'black'
        mult = -1
        start_row = 1
      end
      moves << [row - (2 * mult), col] if can_move(row - (2 * mult), col, board) && row == start_row && !enemy_color(row - (2 * mult), col, board)
      moves << [row - (1 * mult), col] if can_move(row - (1 * mult), col, board) && !enemy_color(row - (1 * mult), col, board)
      moves << [row - (1 * mult), col - 1] if can_move(row - (1 * mult), col - 1, board) && enemy_color(row - (1 * mult), col - 1, board)
      moves << [row - (1 * mult), col + 1] if can_move(row - (1 * mult), col + 1, board) && enemy_color(row - (1 * mult), col + 1, board)
      # Skipping Enpassant
      return moves
    end
  end
end

class Game
  def initialize
    @board = Array.new(8) { Array.new(8,nil) }
    initialize_board
    @player1 = Player.new('white', 'player1')
    @player2 = Player.new('black', 'player2')
  end

  def initialize_board
    (0...8).each{ |col_num|
      @board[1][col_num] = Piece.new('pawn', 'black', [1, col_num])
      @board[6][col_num] = Piece.new('pawn', 'white', [6, col_num])
    }
    create_pieces([0, 7], 'rook')
    create_pieces([1, 6], 'knight')
    create_pieces([2, 5], 'bishop')
    create_pieces([3], 'queen')
    create_pieces([4], 'king')
  end

  def create_pieces(col_array, piece)
    col_array.each { |col_num|
      @board[0][col_num] = Piece.new(piece, 'black', [0, col_num])
      @board[7][col_num] = Piece.new(piece, 'white', [7, col_num])
    }
  end

  def print_board
    system('clear')
    system('cls')
    count = 8
    @board.each { |row|
      print_row = row.map { |piece|
        "\u3000".encode('utf-8') if piece.nil?
        piece
      }
      print count.to_s.concat(' ')
      count -= 1
      puts print_row.join(' ')
    }
    puts '  a b c d e f g h'
  end

  def update_piece_location(player, selected_piece, selected_location)
    target = @board[selected_location[0]][selected_location[1]]
    player.add_graveyard(target) if target.instance_of?(Piece)
    @board[selected_location[0]][selected_location[1]] = selected_piece
    @board[selected_piece.location[0]][selected_piece.location[1]] = nil
    selected_piece.location = selected_location
  end

  def play_game
    loop do
      [@player1, @player2].each { |current_player|
        print_board
        puts "#{current_player.name} (#{current_player.color})'s Turn"
        selected_piece = current_player.pick_piece(@board)
        selected_location = current_player.pick_target(@board, selected_piece.possible_moves(@board))
        update_piece_location(current_player, selected_piece, selected_location)
      }
    end
  end

end

game = Game.new
game.play_game
