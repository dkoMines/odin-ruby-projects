def fibs_rec length
  return 1 if length <= 2
  return fibs_rec(length-1) + fibs_rec(length-2)
end

def fibs length
  return [] if length.zero?
  return [1] if length == 1
  arr = [1, 1]
  until arr.length == length
    arr << arr[-1] + arr[-2]
  end
  return arr
end

def merge(arr1, arr2)
  new_arr = []
  until arr1.nil? || arr2.nil? || arr1.empty? || arr2.empty?
    if arr1[0] < arr2[0]
      new_arr << arr1.shift
    else
      new_arr << arr2.shift
    end
  end
  arr1.each { |item| new_arr << item}
  arr2.each { |item| new_arr << item}
  new_arr
end

def merge_sort(arr)
  return arr if arr.length <= 1
  left_half = merge_sort(arr[0...arr.length/2])
  right_half = merge_sort(arr[arr.length/2..])
  return merge(left_half, right_half)
end

p fibs(12)
p fibs_rec(12)

p [14, 46, 43, 27, 57, 41, 45, 21, 70]
p merge_sort([14, 46, 43, 27, 57, 41, 45, 21, 70])


