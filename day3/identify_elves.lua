character_a_code = string.byte('a')
character_A_code = string.byte('A')

function item_priority(item)
    character_code = string.byte(item)
    if character_code < character_a_code then
        return character_code - character_A_code + 27
    else
        return character_code - character_a_code + 1
    end
end

function compute_priority(groups)
    first_group = groups[1]
    for i = 1, #first_group do
        item = string.sub(first_group, i, i)
        item_count = 0
        for _, group in pairs(groups) do
            found = string.find(group, item)
            if found then
                item_count = item_count + 1
            end
        end

        if item_count == 3 then
            return item_priority(item)
        end
    end
end

priority = 0
groups = {}
for line in io.lines('day3/input.txt') do
    groups[#groups+1] = line
    if #groups == 3 then
        priority = priority + compute_priority(groups)
        groups = {}
    end
end

print(priority)