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

MOVE_MAP = {
    ["AX"] = "AZ",
    ["BX"] = "BX",
    ["CX"] = "CY",
    ["AY"] = "AX",
    ["BY"] = "BY",
    ["CY"] = "CZ",
    ["AZ"] = "AY",
    ["BZ"] = "BZ",
    ["CZ"] = "CX"
    }

function round_score(opponent, me)
    mapped_move = MOVE_MAP[opponent .. me]
    result = SHAPE_SCORES[string.sub(mapped_move, 2, 2)] + ROUND_SCORES[mapped_move]
    return result
end

total_score = 0
for line in io.lines(working_file) do
    opponent, me = string.match(line, "([A-C])%s+([X-Z])")
    total_score = total_score + round_score(opponent, me)
end

print('Total score: ' .. total_score)