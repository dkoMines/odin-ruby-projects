def bubble_sort array
    sorted = false
    until sorted do
        sorted = true
        (0...array.length-1).each do |idx|
            if array[idx] > array[idx+1]
                # Swap idx and idx+1
                tmp = array[idx]
                array[idx] = array[idx+1]
                array[idx+1] = tmp
                sorted = false
            end
        end
    end
    array
end

p bubble_sort([4,3,78,2,0,2])