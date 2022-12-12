hegiht_map = {}
a_value = string.byte('a')
function create_pos(x, y, steps)
    return {
        ["x"] = x,
        ["y"] = y,
        ["steps"] = steps
        }
end
starting_pos = {}
target_pos = create_pos(0, 0)
x_dim = 0

function process_height_line(line)
    height_line = {}
    x_dim = #line
    for i=1, #line do
        ch = line:sub(i, i)
        if ch == 'S' then
            height_line[i] = 0
            starting_pos = create_pos(i, #hegiht_map + 1, 0)
        elseif ch == 'E' then
            height_line[i] = string.byte('z') - a_value
            target_pos = create_pos(i, #hegiht_map + 1, 0)
        else
            height_line[i] = string.byte(ch) - a_value
        end
    end
    hegiht_map[#hegiht_map + 1] = height_line
end

for line in io.lines('day12/input.txt') do
    process_height_line(line)
end

y_dim = #hegiht_map

function can_move(curr, next)
    if next.x < 1 or next.y < 1 or next.x > x_dim or next.y > y_dim then
        return false
    end

    h_next = hegiht_map[next.y][next.x]
    h_curr = hegiht_map[curr.y][curr.x]
    h_diff = h_next - h_curr

    if h_diff < -1 then
        -- print('h(' .. next.x .. ',' .. next.y .. ') = ' .. h_next .. ' h(' .. curr.x .. ',' .. curr.y .. ') = ' .. h_curr)
        return false
    end

    return true
end

looking_for_first_lowest_level = true

function find_target()
    i=0
    Q = {target_pos}

    function Qcontains(pos)
        -- print(pos)
        for _, traveled in pairs(Q) do
            if traveled.x == pos.x and traveled.y == pos.y then
                return true
            end
        end
        return false
    end

    while i < #Q do
        i = i + 1
        -- print(i .. '/' .. #Q)
        working = Q[i]

        if looking_for_first_lowest_level then
            if hegiht_map[working.y][working.x] == 0 then
                return working
            end
        else
            if working.x == starting_pos.x and working.y == starting_pos.y then
                return working
            end
        end

        next_pos = {
            create_pos(working.x - 1, working.y, working.steps + 1),
            create_pos(working.x + 1, working.y, working.steps + 1),
            create_pos(working.x, working.y - 1, working.steps + 1),
            create_pos(working.x, working.y + 1, working.steps + 1)
            }

        for _, pos in pairs(next_pos) do
            if can_move(working, pos) and not Qcontains(pos) then
                Q[#Q + 1] = pos
            end
        end
    end

    -- for y=1, #hegiht_map do
    --     for x=1, x_dim do
    --         if Qcontains(create_pos(x,y)) then
    --             io.write('#')
    --         else
    --             io.write('.')
    --         end
    --     end
    --     print()
    -- end
end

res = find_target()

print(res.x .. ',' .. res.y .. ' steps ' .. res.steps)