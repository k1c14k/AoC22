input_file = io.open('day13/input.txt')


function as_table(val)
    -- local result = {}
    -- result["val"] = {}
    -- result["val"][1] = val
    -- print('ATV')
    -- print(result)
    return {
        ["val"] = {
            {
                ["val"] = val
            }
            }
        }
end


function as_string(tree)
    if type(tree.val) == 'number' then
        return tree.val
    else
        local result = ''
        -- print('TV ')
        -- print(tree.val)
        -- print(tree)
        for _, val in pairs(tree.val) do
            result = result .. ' [' .. as_string(val) .. ']'
        end
        return result
    end
end


function compare(left, right)
    -- print(left)
    -- print(right)
    -- print('Compare ' .. as_string(left) .. ' vs ' .. as_string(right))
    if type(left.val) == 'number' and type(right.val) == 'number' then
        -- print('A')
        return left.val - right.val
    elseif type(left.val) == 'table' and type(right.val) == 'table' then
        -- print('B')


        longer = #left.val
        if #right.val > longer then
            longer = #right.val
        end
        for i=1, longer do
            if left.val[i] == nil then
                return -1
            end
            if right.val[i] == nil then
                return 1
            end

            cmpr = compare(left.val[i], right.val[i])
            if cmpr ~=0 then
                return cmpr
            end
        end

        return #left.val - #right.val
    elseif type(left.val) == 'number' then
        -- print('C')
        return compare(as_table(left.val), right)
    else
        -- print('D')
        return compare(left, as_table(right.val))
    end
end


function tokenize(str)
    local tokens = {}

    pos = 1
    next_num = false
    while pos <= #str do
        ch = str:sub(pos, pos)
        if ch == ',' then
            pos = pos + 1
            next_num = true
        elseif ch == '[' or ch == ']' then
            tokens[#tokens + 1] = ch
            pos = pos + 1
            next_num = true
        else
            if tokens[#tokens] == '[' or tokens[#tokens] == ']' then
                tokens[#tokens + 1] = ch
                next_num = false
            else
                if not next_num then
                    tokens[#tokens] = tokens[#tokens] * 10 + ch
                else
                    tokens[#tokens + 1] = ch
                end
            end
            pos = pos + 1
        end
    end

    return tokens
end


function parse_tree(tokens)
    local result = {
        ["val"] = {}
        }
    working = result

    for _, token in pairs(tokens) do
        if token == '[' then
            if working.val == nil then
                working.val = {}
            end
            working.val[#working.val + 1] = {
                ["parent"] = working,
                ["val"] = {}
                }
            working = working.val[#working.val]
        elseif token == ']' then
            working = working.parent
        else
            if working.val == nil then
                working.val = {}
            end
            -- print(token)
            working.val[#working.val + 1] = {
                ["parent"] = working,
                ["val"] = tonumber(token)
                }
        end
    end

return result.val[1]
end


function parse(str)
    tokens = tokenize(str)

    local result = parse_tree(tokens)
    -- print(as_string(result))

    return result
end


counter = 0
result = 0
all_packets = {}
while true do
    line1 = input_file:read("*line")
    if line1 == nil then
        break
    end
    line2 = input_file:read("*line")
    line3 = input_file:read("*line")

    counter = counter + 1
    -- print('== Pair ' .. counter .. ' ==')
    -- print(line1)
    -- print(line2)
    line1 = parse(line1)
    line2 = parse(line2)
    all_packets[#all_packets + 1] = line1
    all_packets[#all_packets + 1] = line2
    if compare(line1, line2) < 0 then
        result = result + counter
        -- print('Left side is smaller, so inputs are in the right order')
        -- else
        -- print('Right side is smaller, so inputs are not in the right order')
    end
end

print('Solution ' .. result)

divider2 = parse('[[2]]')
divider6 = parse('[[6]]')
all_packets[#all_packets + 1] = divider2
all_packets[#all_packets + 1] = divider6

function compare_fn(a, b)
    return compare(a, b) < 0
end

table.sort(all_packets, compare_fn)

sol2 = 1

for _, packet in pairs(all_packets) do
    if packet == divider2 or packet == divider6 then
        sol2 = sol2 * _
    end
    -- print(as_string(packet))
end

print('Solution ' .. sol2)