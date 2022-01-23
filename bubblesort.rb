def bubble_sort(array)
  sorted = array.length - 1
  until sorted == 0
    (0...sorted).each do |idx|
      next unless array[idx] > array[idx + 1]

      # Swap idx and idx+1
      tmp = array[idx]
      array[idx] = array[idx + 1]
      array[idx + 1] = tmp
      sorted = idx
    end
  end
  array
end

p bubble_sort([4, 3, 78, 2, 0, 2])
