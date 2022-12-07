function is_different_chars(seq, num_distinct)
    for i=1, #seq - 1 do
        c = seq:sub(i, i)
        for j=i + 1, #seq do
            if c == seq:sub(j, j) then
                return false
            end
        end
    end
    return true
end

num_distinct = 14

function detect_first_marker(line)
    result = 0
    seq = line:sub(1,num_distinct)
    line = line:sub(num_distinct + 1, #line)
    while #seq == num_distinct do
        if is_different_chars(seq, num_distinct) then
            return result
        end
        seq = seq:sub(2,num_distinct) .. line:sub(1,1)
        line = line:sub(2, #line)
        result = result + 1
    end
    return result
end

for line in io.lines('day6/input.txt') do
    print(detect_first_marker(line) + num_distinct)
end