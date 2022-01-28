class Node
  include Comparable
  attr_accessor :value, :left, :right

  def <=>(other)
    @value <=> other.value
  end

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def leaf?
    @left.nil? && right.nil?
  end
end

class Tree
  def initialize(root = nil)
    @root = root
  end

  def insert(value)
    return nil unless find(value).nil?

    node = Node.new(value)
    return @root = node if @root.nil?

    current_node = @root
    loop do
      if current_node > node # go left
        return current_node.left = node if current_node.left.nil?

        current_node = current_node.left
      else # go right
        return current_node.right = node if current_node.right.nil?

        current_node = current_node.right
      end
    end
  end

  def smallest(node)
    node = node.left until node.left.nil?
    node
  end

  def delete(value, current_node = @root)
    return nil if current_node.nil?

    if current_node.value > value # Go left
      current_node.left = delete(value, current_node.left)
    elsif current_node.value < value # Go right
      current_node.right = delete(value, current_node.right)
    else # Delete this one
      if current_node.left.nil?
        temp = current_node.right
        current_node = nil
        return temp
      elsif current_node.right.nil?
        temp = current_node.left
        current_node = nil
        return temp
      end
      temp = smallest(current_node.right)
      current_node.value = temp.value
      current_node.right = delete(current_node.right, temp.value)
    end
    current_node
  end

  def level_order(&block)
    queue = [@root]
    until queue.empty?
      current_node = queue.shift
      block.call(current_node) unless current_node.nil?
      queue << current_node.left unless current_node.left.nil?
      queue << current_node.right unless current_node.right.nil?
    end
  end

  def inorder(current_node = @root, &block)
    return if current_node.nil?

    inorder(current_node.left, &block) unless current_node.left.nil?
    block.call(current_node)
    inorder(current_node.right, &block) unless current_node.right.nil?
  end

  def preorder(current_node = @root, &block)
    return if current_node.nil?

    block.call(current_node)
    preorder(current_node.left, &block) unless current_node.left.nil?
    preorder(current_node.right, &block) unless current_node.right.nil?
  end

  def postorder(current_node = @root, &block)
    return if current_node.nil?

    postorder(current_node.left, &block) unless current_node.left.nil?
    postorder(current_node.right, &block) unless current_node.right.nil?
    block.call(current_node)
  end

  def find(value)
    current_node = @root
    loop do
      return nil if current_node.nil?
      return current_node if value == current_node.value

      current_node = if current_node.value > value # Go Left
                       current_node.left
                     else
                       current_node.right
                     end
    end
  end

  def height(node)
    return 0 if node.nil?

    height = 1
    queue = [node]
    next_queue = []
    loop do
      queue.each do |current_node|
        next_queue << current_node.left unless current_node.left.nil?
        next_queue << current_node.right unless current_node.right.nil?
      end
      return height if next_queue.empty?

      height += 1
      queue = next_queue
      next_queue = []
    end
  end

  def depth(node)
    depth = 1
    current_node = @root
    loop do
      return nil if current_node.nil?
      return depth if node == current_node

      current_node = if current_node.value > value # Go Left
                       current_node.left
                     else
                       current_node.right
                     end
      depth += 1
    end
  end

  def balanced?
    queue = [@root]
    until queue.empty?
      current_node = queue.pop
      left_height = current_node.left.nil? ? 0 : height(current_node.left)
      right_height = current_node.right.nil? ? 0 : height(current_node.right)

      difference = (left_height - right_height).abs
      return false if difference > 1

      queue << current_node.left unless current_node.left.nil?
      queue << current_node.right unless current_node.right.nil?
    end
    true
  end

  def rebalance
    return if balanced?

    array = []
    inorder { |item| array << item.value }
    @root = build_tree(to_nodes(array))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

def to_nodes(array)
  array.sort.uniq.map { |num| Node.new(num) }
end

def build_tree(node_array)
  mid = (node_array.length - 1) / 2
  root = node_array[mid]
  root.left = build_tree(node_array[0, mid]) unless node_array[0, mid].empty?
  root.right = build_tree(node_array[mid + 1, node_array.length - 1]) unless node_array[mid + 1,
                                                                                        node_array.length - 1].empty?
  root
end

# arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
# tree1 = Tree.new(build_tree(to_nodes(arr)))
# tree1.pretty_print

arr = (Array.new(15) { rand(1..100) })
tree2 = Tree.new(build_tree(to_nodes(arr)))
tree2.pretty_print
p tree2.balanced? ? 'Balanced' : 'Unbalanced'
p 'Preorder'
tree2.preorder { |item| print "#{item.value} ; " }
puts
p 'Postorder'
tree2.postorder { |item| print "#{item.value} ; " }
puts
p 'Inorder'
tree2.inorder { |item| print "#{item.value} ; " }
puts
p 'Insert 15'
tree2.insert(15)
tree2.inorder { |item| print "#{item.value} ; " }
puts
p 'Delete 15'
tree2.delete(15)
tree2.inorder { |item| print "#{item.value} ; " }
puts
10.times do
  tree2.insert(rand(1..100))
end
p 'Insert 10 random'
tree2.inorder { |item| print "#{item.value} ; " }
puts
p tree2.balanced? ? 'Balanced' : 'Unbalanced'
tree2.pretty_print
p 'Rebalance'
tree2.rebalance
p tree2.balanced? ? 'Balanced' : 'Unbalanced'
tree2.pretty_print
p 'Level Order'
tree2.level_order { |item| print "#{item.value} ; " }
puts