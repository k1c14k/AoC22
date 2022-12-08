trees = {}
for line in io.lines('day8/input.txt') do
    row = {}
    for i=1, #line do
        row[i] = tonumber(line:sub(i,i))
    end
    trees[#trees+1] = row
end

function check_top(row, column)
    if row == 1 then
        return 0
    end

    result = 0
    for r=row -1, 1, -1 do
        result = result + 1
        if trees[r][column] >= trees[row][column] then
            -- print('TOP ' .. result)
            return result
        end
    end

    -- print('TOP ' .. result)
    return result
end

function check_bottom(row, column)
    if row == #trees then
        return 0
    end

    result = 0
    for r=row + 1, #trees do
        result = result + 1
        if trees[r][column] >= trees[row][column] then
            -- print('BOTTOM ' .. result)
            return result
        end
    end
    -- print('BOTTOM ' .. result)
    return result
end

function check_left(row, column)
    if column == 1 then
        return 0
    end

    result = 0
    for c=column - 1, 1, -1 do
        result = result + 1
        if trees[row][c] >= trees[row][column] then
            -- print('LEFT ' .. result)
            return result
        end
    end
    -- print('LEFT ' .. result)
    return result
end

function check_right(row, column)
    if column == #trees[row] then
        return 0
    end

    result = 0
    for c=column + 1, #trees[row] do
        result = result + 1
        if trees[row][c] >= trees[row][column] then
            -- print('RIGHT ' .. result)
            return result
        end
    end
    -- print('RIGHT ' .. result)
    return result
end

function tree_score(row, column)
    return check_top(row, column) * check_left(row, column) * check_right(row, column) * check_bottom(row, column)
end

max_tree_score = 0

for row=2, #trees - 1 do
    for column=2, #trees[row] - 1 do
        score = tree_score(row, column)
        -- print(row .. ',' .. column .. ' ' .. score)
        if max_tree_score < score then
            max_tree_score = score
        end
    end
end

print('Solution 2: ' .. max_tree_score)