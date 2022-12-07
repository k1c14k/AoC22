character_a_code = string.byte('a')
character_A_code = string.byte('A')

function compute_priority(comp1, comp2)
    for i=1, #comp1 do
        item = string.sub(comp1, i, i)
        found = string.find(comp2, item)
        if found then
            character_code = string.byte(item)
            if character_code < character_a_code then
                return character_code - character_A_code + 27
                else
                    return character_code - character_a_code + 1
                end
            end
        end
    end
    return 0
end

priority = 0
for line in io.lines('day3/input.txt') do
    comp1 = string.sub(line, 1, #line/2)
    comp2 = string.sub(line, #line/2 + 1, #line)
    priority = priority + compute_priority(comp1, comp2)
end

print(priority)
