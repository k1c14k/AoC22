head_x = 0
head_y = 0
tail_x = 0
tail_y = 0

tail_positions = {
    ['0,0'] = 1
    }

function move_tail()
    in_x_radius = (head_x - 1 <= tail_x) and (tail_x <= head_x + 1)
    in_y_radius = (head_y - 1 <= tail_y) and (tail_y <= head_y + 1)

    while not (in_x_radius and in_y_radius) do
        -- print('H(' .. head_x .. ',' .. head_y .. ') T(' .. tail_x .. ',' .. tail_y .. ')')
--        if not(in_x_radius) then
            if tail_x < head_x then
                tail_x = tail_x + 1
            elseif tail_x > head_x then
                tail_x = tail_x - 1
            end
--        else
            if tail_y < head_y then
                tail_y = tail_y + 1
            elseif tail_y > head_y then
                tail_y = tail_y - 1
            end
--        end
        tail_positions[tail_x .. ',' .. tail_y] = 1
        in_x_radius = (head_x - 1 <= tail_x) and (tail_x <= head_x + 1)
        in_y_radius = (head_y - 1 <= tail_y) and (tail_y <= head_y + 1)
    end
    -- print('H(' .. head_x .. ',' .. head_y .. ') T(' .. tail_x .. ',' .. tail_y .. ')')
end

function move(direction, units)
    if direction == 'D' then
        direction = 'U'
        units = -units
    elseif direction == 'L' then
        direction = 'R'
        units = -units
    end

    if direction == 'R' then
        head_x = head_x + units
    else
        head_y = head_y + units
    end

    move_tail()
end

for line in io.lines('day9/inputT.txt') do
    direction, units = line:match('(%a) (%d+)')
    units = tonumber(units)
    move(direction, units)
end

visited_tiles = 0
for pos, _ in pairs(tail_positions) do
    visited_tiles = visited_tiles + 1
    print(pos)
end

print(visited_tiles)