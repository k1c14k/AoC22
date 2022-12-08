trees = {}
for line in io.lines('day8/input.txt') do
    row = {}
    for i=1, #line do
        row[i] = tonumber(line:sub(i,i))
    end
    trees[#trees+1] = row
end

function check_top(row, column)
    for r=1, row -1 do
        if trees[r][column] >= trees[row][column] then
            -- print('Failed row ' .. r)
            return false
        end
    end

    return true
end

function check_bottom(row, column)
    for r=row+1, #trees do
        if trees[r][column] >= trees[row][column] then
            -- print('Failed row ' .. r)
            return false
        end
    end

    return true
end

function check_left(row, column)
    for c=1, column -1 do
        if trees[row][c] >= trees[row][column] then
            -- print('Failed column ' .. c)
            return false
        end
    end

    return true
end

function check_right(row, column)
    for c=column + 1, #trees[row] do
        if trees[row][c] >= trees[row][column] then
            -- print('Failed column ' .. c)
            return false
        end
    end

    return true
end

function is_exterior(row, column)
    if row == #trees or row == 1 or column == 1 or column == #trees[row] then
        return true
    end
    return false
end

function is_visible(row, column)
    -- print('Checking ' .. row .. ' ' .. column)
    if is_exterior(row, column) or check_top(row,column) or check_left(row, column) or check_right(row, column) or check_bottom(row, column) then
        return 1
    end

    return 0
end

trees_visible = 0

for row=1, #trees do
    for column=1, #trees[row] do
        trees_visible = trees_visible + is_visible(row, column)
    end
end

print('Solution 1: ' .. trees_visible)