tick = 0
tick_offset = 0
reported_ticks = 1
register = 1
report = 0
screen_width = 40

rendered_row = ''

function reset_row()
    rendered_row = ''
    for _=1, screen_width do
        rendered_row = rendered_row .. '.'
    end
end

reset_row()

function do_tick(tick_num)
    for _=1, tick_num do
        tick = tick + 1
        pixelnum = (tick - 1) % screen_width
        if (register >= pixelnum - 1) and ( register <= pixelnum + 1) then
            -- print(rendered_row)
            -- print(rendered_row:sub(1, pixelnum))
            -- print(rendered_row:sub(pixelnum + 1, #rendered_row))
            rendered_row = rendered_row:sub(1, pixelnum) .. '#' .. rendered_row:sub(pixelnum + 2, #rendered_row)
        end

        if (tick + tick_offset) / 40 >= reported_ticks then
            reported_ticks = reported_ticks + 1
            -- print(tick .. ' ' .. register .. ' ' .. (40 * reported_ticks - 20))
            report = report + tick * register
            print(rendered_row)
            reset_row()
        end
    end
end

function addx(x)
    do_tick(2)
    register = register + x
end

function noop()
    do_tick(1)
end

for line in io.lines('day10/input.txt') do
    command, argument = line:match('(%a+)(.*)')
    argument = argument:match(' (-?%d+)')
    if command == 'addx' then
        addx(tonumber(argument))
    elseif command == 'noop' then
        noop()
    end
end

print(report)