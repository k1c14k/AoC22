PROD_INPUT_FILE_NAME = 'day15/input.txt'
TEST_INPUT_FILE_NAME = 'day15/inputT.txt'


function create_pos(x, y)
    return {
        ["x"] = x,
        ["y"] = y
        }
end


function load_sensors(file_name)
    local result = {}
    for line in io.lines(file_name) do
        sensor_x, sensor_y, beacon_x, beacon_y = line:match('Sensor at x=(-?%d+), y=(-?%d+): closest beacon is at x=(-?%d+), y=(-?%d+)')
        result[#result + 1] = {
            ["sensor"] = create_pos(sensor_x, sensor_y),
            ["beacon"] = create_pos(beacon_x, beacon_y)
            }
    end
    return result
end


function find_x_ranges(sensors, y)
    local result = {}
    for _, sensor in pairs(sensors) do
        xs, ys, xb, yb = sensor.sensor.x, sensor.sensor.y, sensor.beacon.x, sensor.beacon.y
        d = math.abs(xs - xb) + math.abs(ys - yb)
        x1 = math.abs(ys - y) + xs - d
        x2 = d - math.abs(ys - y) + xs
        if x1 <= x2 then
            result[#result + 1] = {x1, x2}
        end
    end
    return result
end


function put_range(ranges, to_put)
    for i=1, #ranges do
        range = ranges[i]
        x1, x2, x3, x4 = range[1], range[2], to_put[1], to_put[2]
        if x1 > x3 then
            x1, x2, x3, x4 = x3, x4, x1, x2
        end
        if x3 - 1 <= x2 then
            if x2 <= x4 then
                ranges[i] = {x1, x4}
            else
                ranges[i] = {x1, x2}
            end
            return
        end
    end
    ranges[#ranges + 1] = to_put
end


function merge_ranges(x_ranges)
    local result = {x_ranges[1]}
    for i=2, #x_ranges do
        put_range(result, x_ranges[i])
    end
    return result
end


function optimize(x_ranges)
    local result = x_ranges
    repeat
        p = #result
        result = merge_ranges(result)
    until p <= #result
    return result
end


function count_points_in_ranges(x_ranges)
    local result = 0
    for _, range in pairs(x_ranges) do
        result = result + math.abs(range[2] - range[1])
    end
    return result
end


function filter_ranges(ranges, min_x, max_x)
    local result = {}
    for _, range in pairs(ranges) do
        if range[2] >= min_x and range[1] <= max_x then
            result[#result + 1] = range
        end
    end
    return result
end


function find_beacon(sensors, max_coordinate)
    -- progress = 0
    -- prev_reported = -1
    for y=0, max_coordinate do
        -- progress = (100 * y // max_coordinate)
        -- if progress > prev_reported then
        -- print('Testing y = ' .. y .. ' / ' .. max_coordinate .. ' (' .. progress .. '%)')
        --     prev_reported = progress
        -- end
        ranges = optimize(find_x_ranges(sensors, y))
        ranges = filter_ranges(ranges, 0, max_coordinate)
        if #ranges == 2 then
            x1, x2, x3, x4 = ranges[1][1], ranges[1][2], ranges[2][1], ranges[2][2]
            if x1 > x3 then
                x1, x2, x3, x4 = x3, x4, x1, x2
            end
            -- print(y, x1, x2, x3, x4)
            return (x2 + 1) * 4000000 + y
        end
    end
end


function solve(file_name, y, max_coordinate)
    local solution = {}
    sensors = load_sensors(file_name)
    x_ranges = find_x_ranges(sensors, y)
    -- print(#x_ranges)
    x_ranges = optimize(x_ranges)
    -- print(#x_ranges)
    -- for _, range in pairs(x_ranges) do
    --     print(range[1], range[2])
    -- end
    solution[1] = count_points_in_ranges(x_ranges)
    solution[2] = find_beacon(sensors, max_coordinate)

    return solution
end

-- solution = solve(TEST_INPUT_FILE_NAME, 10, 20)
solution = solve(PROD_INPUT_FILE_NAME, 2000000, 4000000)

print('Solution 1: ' .. solution[1])
print('Solution 2: ' .. solution[2])
