knots = {}
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }
knots[#knots + 1] = { ['x'] = 0, ['y'] = 0 }

tail_positions = {
    ['0,0'] = 1
    }

function move_tail(tail)
    head_x = knots[tail-1]['x']
    head_y = knots[tail-1]['y']
    tail_x = knots[tail]['x']
    tail_y = knots[tail]['y']
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
        knots[tail]['x'] = tail_x
        knots[tail]['y'] = tail_y
        if tail == #knots then
            tail_positions[tail_x .. ',' .. tail_y] = 1
        end

        in_x_radius = (head_x - 1 <= tail_x) and (tail_x <= head_x + 1)
        in_y_radius = (head_y - 1 <= tail_y) and (tail_y <= head_y + 1)
    end
    -- print('H(' .. head_x .. ',' .. head_y .. ') T(' .. tail_x .. ',' .. tail_y .. ')')
end

function move(direction)
    units = 1
    if direction == 'D' then
        direction = 'U'
        units = -units
    elseif direction == 'L' then
        direction = 'R'
        units = -units
    end

    if direction == 'R' then
        knots[1]['x'] = knots[1]['x'] + units
    else
        knots[1]['y'] = knots[1]['y'] + units
    end

    for tail=2, #knots do
        move_tail(tail)
    end
end

for line in io.lines('day9/input.txt') do
    direction, units = line:match('(%a) (%d+)')
    units = tonumber(units)
    for _=1, units do
        move(direction)
    end
end

visited_tiles = 0
for pos, _ in pairs(tail_positions) do
    visited_tiles = visited_tiles + 1
    -- print(pos)
end

print(visited_tiles)