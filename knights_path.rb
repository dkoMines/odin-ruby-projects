def possible_moves(original_location)
  moves = []
  # 2 v, 1 h
  verticals = [-2, 2]
  horizontals = [-1, 1]
  verticals.each { |v| 
    horizontals.each { |h|
      new_pos = [original_location[0] + v, original_location[1] + h]
      moves << new_pos if new_pos.all? { |coord| coord >= 0 && coord < 8}
    }
  }
  # 1 v, 2 h
  horizontals = [-2, 2]
  verticals = [-1, 1]
  verticals.each { |v| 
    horizontals.each { |h|
      new_pos = [original_location[0] + v, original_location[1] + h]
      moves << new_pos if new_pos.all? { |coord| coord >= 0 && coord < 8}
    }
  }
  moves
end

class Node
  attr_accessor :location, :turn, :next_moves, :parent_node
  def initialize(location, turn, parent_node = nil)
    @location = location
    @turn = turn
    @next_moves = []
    @parent_node = parent_node
  end
end

class MoveTree
  def initialize(root)
    @root = root
  end

  def includes?(location, parent = @root)
    return true if parent.location == location
    return false if parent.next_moves.empty?
    parent.next_moves.each { |next_move|
      return true if includes?(location, next_move)
    }
    false
  end

  def find_path(node)
    arr = [node.location]
    until node.parent_node.nil?
      node = node.parent_node
      arr << node.location
    end
    arr.reverse
  end
end


def knight_moves(start_loc, finish_loc)
  root = Node.new(start_loc, 0)
  tree = MoveTree.new(root)
  queue = [root]
  current_move = root
  until queue.empty? || current_move.location == finish_loc
    current_move = queue.shift
    possible_moves(current_move.location).each { |location|
      unless tree.includes?(location)
        node = Node.new(location, current_move.turn + 1, current_move)
        current_move.next_moves << node
        queue << node
      end
    }
  end
  puts "You made it in #{current_move.turn} moves! Here's your path"
  path = tree.find_path(current_move)
  path.each { |location| puts "   #{location}" } 

end


knight_moves([3, 3], [4, 3])
