function parse_assignment(line)
    elve_sep = string.find(line, ',')
    elve1 = string.sub(line, 1, elve_sep - 1)
    elve2 = string.sub(line, elve_sep + 1, #line)
    elve1_sep = string.find(elve1, '-')
    elve1_begin = string.sub(elve1, 1, elve1_sep - 1)
    elve1_end = string.sub(elve1, elve1_sep + 1, #elve1)
    elve2_sep = string.find(elve2, '-')
    elve2_begin = string.sub(elve2, 1, elve2_sep - 1)
    elve2_end = string.sub(elve2, elve2_sep + 1, #elve2)
    -- print('# line ' .. line .. ' elve2 ' .. elve2 .. ' elve2_sep ' .. elve2_sep .. ' elve2_begin ' .. elve2_begin .. ' elve2_end ' .. elve2_end)

    return {
        ['elve1_begin'] = tonumber(elve1_begin),
        ['elve1_end'] = tonumber(elve1_end),
        ['elve2_begin'] = tonumber(elve2_begin),
        ['elve2_end'] = tonumber(elve2_end)
        }
end

function is_overlaping(assignment, containing)
    if containing then
        if (assignment['elve1_begin'] <= assignment['elve2_begin']) and (assignment['elve2_end'] <= assignment['elve1_end']) then
            return true
        elseif (assignment['elve2_begin'] <= assignment['elve1_begin']) and (assignment['elve1_end'] <= assignment['elve2_end']) then
            return true
        else
            return false
        end
    else
        if (assignment['elve1_begin'] <= assignment['elve2_end']) and (assignment['elve1_end'] >= assignment['elve2_begin']) then
            return true
        elseif (assignment['elve2_begin'] <= assignment['elve1_end']) and (assignment['elve2_end'] >= assignment['elve1_begin']) then
            return true
        else
            return false
        end
    end
end

overlaping_count = 0
-- ln = 0
for line in io.lines('day4/input.txt') do
    -- ln = ln + 1
    -- print(ln)
    assignment = parse_assignment(line)
    -- print('elve1_begin ' .. assignment['elve1_begin'] .. ' elve1_end ' .. assignment['elve1_end'] .. ' elve2_begin ' .. assignment['elve2_begin'] .. ' elve2_end ' .. assignment['elve2_end'])
    if is_overlaping(assignment) then
        overlaping_count = overlaping_count + 1
    end
end

print(overlaping_count)