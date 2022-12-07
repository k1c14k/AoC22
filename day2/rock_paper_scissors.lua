working_file = 'day2/input.txt'

SHAPE_SCORES = {
    ["X"] = 1,
    ["Y"] = 2,
    ["Z"] = 3
    }

ROUND_SCORES = {
    ["AX"] = 3,
    ["BX"] = 0,
    ["CX"] = 6,
    ["AY"] = 6,
    ["BY"] = 3,
    ["CY"] = 0,
    ["AZ"] = 0,
    ["BZ"] = 6,
    ["CZ"] = 3
    }

-- why it ain't work????
-- function win_score(opponent, me)
--     if (opponent == 'A' and me == 'Y') or (opponen == 'B' and me == 'Z') or (opponent == 'C' and me == 'X') then
--         return 6
--     elseif (opponent == 'A' and me == 'X') or (opponent == 'B' and me == 'Y') or (opponent == 'C' and me == 'Z') then
--         return 3
--     else
--         return 0
--     end
-- end

function round_score(opponent, me)
    result = SHAPE_SCORES[me] + ROUND_SCORES[opponent .. me]
    return result
end

total_score = 0
for line in io.lines(working_file) do
    opponent, me = string.match(line, "([A-C])%s+([X-Z])")
    total_score = total_score + round_score(opponent, me)
end

print('Total score: ' .. total_score)