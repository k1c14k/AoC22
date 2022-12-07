stacks = {}

input = io.open('day5/input.txt')
stacks = {}

while true do
    line = input:read()
    if (line == nil) or (line:match('^%s*$')) then
        break
    end
    stack = 0
    while #line > 0 do
        stack = stack + 1
        segment = line:sub(1, 4)
        line = line:sub(5, #line)

        item = segment:match('[%a]')
        if item ~= nil then
            if stacks[stack] == nil then
                stacks[stack] = {}
            end
            stacks[stack][#stacks[stack]+1] = item
        end
    end
end

function reverse(tbl)
    res = {}
    for i=#tbl, 1, -1 do
        res[#res+1] = tbl[i]
    end
    return res
end

for _, stack in pairs(stacks) do
    stacks[_]=reverse(stack)
end

while true do
    line = input:read()
    if (line == nil) then
        break
    end
    items, stack_from, stack_to = line:match('move (%d*) from (%d*) to (%d*)')
    items = tonumber(items)
    stack_from = tonumber(stack_from)
    stack_to = tonumber(stack_to)

    to_move = {}
    for _=1, items do
        item = table.remove(stacks[stack_from])
        to_move[#to_move+1] = item
    end
    for i=#to_move, 1, -1 do
        table.insert(stacks[stack_to], to_move[i])
    end
    for _, stack in pairs(stacks) do
        print(_)
        for __, item in pairs(stack) do
            print(item)
        end
            print('----')
    end
    print('======')
end

result = ''
for i=1,#stacks do
    result = result .. stacks[i][#stacks[i]]
end

print(result)