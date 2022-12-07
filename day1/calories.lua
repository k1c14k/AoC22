function lines_from_file(file)
    local lines = {}

    for line in io.lines(file) do
        lines[#lines+1] = line
    end

    return lines
end

local file = 'day1/input.txt'
local lines = lines_from_file(file)

local counter = 0
local numtopelves = 3
local topelves = {}

function compare(a,b)
    return a>b
end

function put_elve(te, elve)
    if #te < numtopelves then
        table.insert(te, elve)
    elseif elve > te[numtopelves] then
        te[#te+1] = elve
        table.sort(te, compare)
        te[#te] = nil
    end
end

for i, line in pairs(lines) do
    local item = tonumber(line)

    if item ~= nil then
        counter = counter + item
    else
        put_elve(topelves, counter)
        counter = 0
    end
end

put_elve(topelves, counter)

print('Maximum elve\'s calories: ' .. topelves[1])

local top3elves = 0

for pos, elve in pairs(topelves) do
    top3elves = top3elves + elve
end

print('Sum of top 3 elves: ' .. top3elves)