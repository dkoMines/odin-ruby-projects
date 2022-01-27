class LinkedList
  attr_reader :head, :tail

  def initialize()
    @head = nil
    @tail = nil
  end

  def empty?
    @head.nil? && @tail.nil?
  end

  def prepend(value)
    if empty?
      node = Node.new(value, nil)
      @head = node
      @tail = node
    else
      node = Node.new(value, @head)
      @head = node
    end
    self
  end

  def append(value)
    if empty?
      node = Node.new(value, nil)
      @head = node
      @tail = node
    else
      node = Node.new(value, nil)
      @tail.next_node = node
      @tail = node
    end
    self
  end

  def at(index)
    current_node = @head
    raise IndexError if index >= size || index.negative?
    index.times {
      current_node = current_node.next_node
    }
    current_node
  end

  def find(value)
    current_node = @head
    count = 0
    until current_node.nil?
      if current_node.value == value
        return count
      end
      count += 1
      current_node = current_node.next_node
    end
    nil
  end

  def contains?(value)
    !find(value).nil?
  end

  def size
    count = 0
    current_node = @head
    until current_node.nil?
      count += 1
      current_node = current_node.next_node
    end
    count
  end

  def pop
    nil if empty?
    tmp = at(size-1)
    @tail = at(size-2)
    @tail.next_node = nil
    tmp
  end

  def to_s
    if empty?
      return 'nil'
    end
    values = []
    current_node = @head
    until current_node.nil?
      values << current_node.value
      current_node = current_node.next_node
    end
    values.map { |v| "(#{v})"}.join(' -> ') + ' -> nil'
  end
end


class Node
  attr_accessor :next_node, :value

  def initialize(value, next_node)
    @value = value
    @next_node = next_node
  end
end

linked_list = LinkedList.new()
linked_list.append(3)
linked_list.append(4)
linked_list.prepend(2)
linked_list.prepend(1)
linked_list.append(5)
linked_list.append(6)


p linked_list.size
p linked_list.to_s
p linked_list.find(3)
p linked_list.at(2)

linked_list.pop
p linked_list.to_s

p linked_list.contains?(7)
p linked_list.contains?(2)

