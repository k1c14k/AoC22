SAND_SOURCE = {
    ["x"] = 500,
    ["y"] = 0
    }

INPUT_FILE = 'day14/input.txt'

function parse_line(line)
    local result = {}

    while line ~= nil do
        pos_x, pos_y, line = line:match('(%d+),(%d+)(.*)')
        line = line:match(' %-> (.+)')
        -- print(pos_x, pos_y, line)
        -- print(pos_x)
        result[#result + 1] = {
            ["x"] = tonumber(pos_x),
            ["y"] = tonumber(pos_y)
            }
    end

    return result
end


function contains_line(result, A, B)
    for _, line in pairs(result) do
        C, D = line
        if A.x == C.x and A.y == C.y and B.x == D.x and B.y == D.y then
            return true
        end
    end
    return false
end


function put_line(result, A, B)
    if A.x > B.x then
        A, B = B, A
    end

    if A.y > B.y then
        A, B = B, A
    end

    if not contains_line(result, A, B) then
        result[#result + 1] = {A, B}
    end

end


function merge(L1, L2)
    A, B, C, D = L1[1], L1[2], L2[1], L2[2]

    if A.x == B.x and B.x == C.x and C.x == D.x then
        if A.y > C.y then
            A, B, C, D = C, D, A, B
        end
        if A.y < D.y and B.y >= C.y then
            return {A, D}
        elseif A.y <= C.y and B.y >= D.y then
            return {A, B}
        end
    elseif A.y == B.y and B.y == C.y and C.y == D.y then
        if A.x > C.x then
            A, B, C, D = C, D, A, B
        end
        if A.x < D.x and B.x >= C.x then
            return {A, D}
        elseif A.x <= C.x and B.x >= D.x then
            return {A, B}
        end
    end
end


function try_merge(result, line)
    for i=1, #result do
        merged = merge(result[i], line)

        if merged ~= nil then
            result[i] = merged
            return
        end
    end

    result[#result + 1] = line
end


function merge_lines(lines)
    local result = {}

    for _, line in pairs(lines) do
        try_merge(result, line)
    end

    return result
end


function optimize_lines(lines)
    local result = {}

    for _, line in pairs(lines) do
        for i=1, #line - 1 do
            put_line(result, line[i], line[i + 1])
        end
    end

    return merge_lines(result)
end


function read_lines()
    local result = {}

    for ln in io.lines(INPUT_FILE) do
        result[#result + 1] = parse_line(ln)
    end

    previous_step = #result
    -- print('Optimized from ' .. previous_step .. ' to ' .. #result)
    result = optimize_lines(result)
    -- print('Optimized from ' .. previous_step .. ' to ' .. #result)
    while previous_step > #result do
        previous_step = #result
        result = optimize_lines(result)
        -- print('Optimized from ' .. previous_step .. ' to ' .. #result)
    end

    return result
end

function find_x_range(lines)
    local result = {}

    for _, line in pairs(lines) do
        for _, point in pairs(line) do
            if result.min == nil or point.x < result.min then
                -- print('min')
                result.min = point.x
            end
            if result.max == nil or point.x > result.max then
                -- print('max')
                result.max = point.x
            end
            if result.ymax == nil or point.y > result.ymax then
                result.ymax = point.y
            end
        end
    end

    return result
end

lines = read_lines()
-- print(#lines)


function copy_pos(pos)
    return {
        ["x"] = pos.x,
        ["y"] = pos.y
        }
end

function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end


function is_on_line(A, B, pos_x, pos_y)
    -- sleep(0.1)
    -- print('Testing (' .. pos_x .. ',' .. pos_y .. ') on line (' .. A.x .. ',' .. A.y .. ') -> (' .. B.x .. ',' .. B.y .. ')')

    if (A.y == B.y) and (pos_y == A.y) and (pos_x >= A.x) and (pos_x <= B.x) then
        return true
    end

    if (A.x == B.x) and (pos_x == A.x) and (pos_y >= A.y) and (pos_y <= B.y) then
        return true
    end

    return false
end


function is_taken_line(lines, pos_x, pos_y, x_range, infinite_line)
    if pos_y == x_range.ymax + 2 then
        return true
    end

    for _, line in pairs(lines) do
        A, B = line[1], line[2]
        if is_on_line(A, B, pos_x, pos_y) then
            -- print('TL')
            return true
        end
    end

    return false
end


function is_taken_sand(sand_blocks, pos_x, pos_y)
    for _, block in pairs(sand_blocks) do
        if block.x == pos_x and block.y == pos_y then
            -- print('TS')
            return true
        end
    end

    return false
end


cache = {}
function put_cache(pos_x, pos_y, val)
    local k0 = 'P' .. (pos_x // 100)
    local k1 = 'X' .. pos_x
    local k2 = 'Y' .. pos_y

    if cache[k0] == nil then
        cache[k0] = {}
    end

    if cache[k0][k1] == nil then
        cache[k0][k1] = {}
    end

    cache[k0][k1][k2] = val
end

function get_cache(pos_x, pos_y)
    local k0 = 'P' .. (pos_x // 100)
    local k1 = 'X' .. pos_x
    local k2 = 'Y' .. pos_y

    if cache[k0] == nil or cache[k0][k1] == nil then
        return nil
    end

    return cache[k0][k1][k2]
end


function is_taken(lines, sand_blocks, pos_x, pos_y, x_range, infinite_line)
    local res = get_cache(pos_x, pos_y)
    if res ~= nil then
        return res
    end
    -- res = is_taken_sand(sand_blocks, pos_x, pos_y) or is_taken_line(lines, pos_x, pos_y, x_range, infinite_line)
    res = is_taken_line(lines, pos_x, pos_y, x_range, infinite_line)
    if res == true then
        put_cache(pos_x, pos_y, res)
    end
    return res
end


function simulate_fall(lines, sand_blocks, x_range, infinite_line)
    local falling_block = sand_blocks[#sand_blocks]

    while true do
        -- print(sand_blocks[#sand_blocks].x .. ',' .. sand_blocks[#sand_blocks].y)
        if (falling_block.y + 1 > x_range.ymax) and not infinite_line then
            return false
        elseif not is_taken(lines, sand_blocks, falling_block.x, falling_block.y + 1, x_range, infinite_line) then
            -- print('A')
            falling_block.y = falling_block.y + 1
        elseif (falling_block.x - 1 < x_range.min) and not infinite_line then
            -- print('B')
            return false
        elseif not is_taken(lines, sand_blocks, falling_block.x - 1, falling_block.y + 1, x_range, infinite_line) then
            -- print('C')
            falling_block.x = falling_block.x - 1
            falling_block.y = falling_block.y + 1
        elseif (falling_block.x + 1 > x_range.max) and not infinite_line then
            -- print('D')
            return false
        elseif not is_taken(lines, sand_blocks, falling_block.x + 1, falling_block.y + 1, x_range, infinite_line) then
            -- print('E')
            falling_block.x = falling_block.x + 1
            falling_block.y = falling_block.y + 1
        else
            -- print('F')
            if falling_block.x == SAND_SOURCE.x and falling_block.y == SAND_SOURCE.y then
                return false
            end
            put_cache(falling_block.x, falling_block.y, true)
            return true
        end
    end
end


function sand_capacity(lines)
    local result = 0

    local x_range = find_x_range(lines)
    -- print(x_range.min .. ',' .. x_range.max)
    local sand_blocks = {}

    while true do
        -- print('---')
        sand_blocks[#sand_blocks + 1] = copy_pos(SAND_SOURCE)
        if not simulate_fall(lines, sand_blocks, x_range, true) then
            break
        end
        -- print(sand_blocks[#sand_blocks].x .. ',' .. sand_blocks[#sand_blocks].y .. ' Infinite line: ' .. x_range.ymax)
    end

    return #sand_blocks - 1
end

print('Solution: ' .. sand_capacity(lines))