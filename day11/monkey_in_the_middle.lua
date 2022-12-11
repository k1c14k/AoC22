worry_level_decrease = false
rounds = 10000


function read_monkeys()
    file = io.open('day11/input.txt')
    monkeys = {}

    while true do
        monkey_name = file:read('*line')
        if monkey_name == nil then
            return monkeys
        end

        monkey_items = file:read('*line')
        monkey_operation = file:read('*line')
        monkey_test = file:read('*line')
        monkey_condition_true = file:read('*line')
        monkey_condition_false = file:read('*line')
        monkey_separator = file:read('*line')

        monkey_name = monkey_name:match('Monkey (%d+):')
        monkey_name = tonumber(monkey_name) + 1

        items = {}
        for item in monkey_items:gmatch(' (%d+)') do items[#items + 1] = tonumber(item) end
        monkey_items = items

        monkey_operation = monkey_operation:match('Operation: (.+)')
        monkey_operation = load('return function(old) ' .. monkey_operation .. ' return new end')()

        monkey_test = monkey_test:match('divisible by (%d+)')
        monkey_test = tonumber(monkey_test)

        monkey_condition_true = monkey_condition_true:match('to monkey (%d+)')
        monkey_condition_true = tonumber(monkey_condition_true) + 1
        monkey_condition_false = monkey_condition_false:match('to monkey (%d+)')
        monkey_condition_false = tonumber(monkey_condition_false) + 1

        monkey = {
            ["items"] = monkey_items,
            ["operation"] = monkey_operation,
            ["test"] = monkey_test,
            ["true"] = monkey_condition_true,
            ["false"] = monkey_condition_false,
            ["inspections"] = 0
            }

        monkeys[monkey_name] = monkey
    end
end

monkeys = read_monkeys()

for _, monkey in pairs(monkeys) do
    new_items = {}

    for item_i=1, #monkey["items"] do
        new_item = {}
        for i, other_monkey in pairs(monkeys) do
            new_item[i] = {
                ["base"] = other_monkey["test"],
                ["val"] = monkey["items"][item_i] % other_monkey["test"]
                }
        end
        new_items[#new_items + 1] = new_item
    end

    monkey["items"] = new_items
end

function calculate_next(arr, func)
    result = {}
    for i, item in pairs(arr) do
        result[i] = {
            ["base"] = item["base"],
            ["val"] = func(item["val"]) % item["base"]
            }
        -- print('base ' .. item["base"] .. ' value ' .. result[i]["val"])
    end
    return result
end

function process_monkey(monkey, monkey_name)
    -- print(monkey_name)
    -- print(#monkey["items"])
    for _, item in pairs(monkey["items"]) do
        -- print('  Monkey inspects an item with a worry level of ' .. item .. '.')
        monkey["inspections"] = monkey["inspections"] + 1
        next = calculate_next(item, monkey["operation"])
        -- print('    Worry level is changed to ' .. next .. '.')
        if worry_level_decrease then
            next = next // 3
            -- print('    Monkey gets bored with item. Worry level is divided by 3 to ' .. new .. '.')
        end

        if next[monkey_name]["val"] == 0 then
            -- print('    Current worry level is divisible by ' .. monkey["test"] .. '.')
            -- print('    Item with worry level ' .. next .. ' is thrown to monkey ' .. monkey["true"] - 1 .. '.')
            monkeys[monkey["true"]]["items"][#monkeys[monkey["true"]]["items"] + 1] = next
        else
            -- print('    Current worry level is not divisible by ' .. monkey["test"] .. '.')
            -- print('    Item with worry level ' .. next .. ' is thrown to monkey ' .. monkey["false"] - 1 .. '.')
            monkeys[monkey["false"]]["items"][#monkeys[monkey["false"]]["items"] + 1] = next
        end
    end

    monkey["items"] = {}
end


for _=1, rounds do
    for monkey_name, monkey in pairs(monkeys) do
        -- print('Processing monkey ' .. monkey_name - 1)
        process_monkey(monkey, monkey_name)
    end

    -- print(_ .. ' / ' .. rounds)

--    for monkey_name, monkey in pairs(monkeys) do
--        monkey_items = ''
--        for _, item in pairs(monkey["items"]) do monkey_items = monkey_items .. ' ' .. item end
--        print('Monkey ' .. (monkey_name - 1) .. ': ' .. monkey_items)
--    end
end

top_inspectors = {0,0}

for monkey_name, monkey in pairs(monkeys) do
    -- print('Monkey ' .. (monkey_name - 1) .. ' inspected items ' .. monkey["inspections"] .. ' times.')
    insp = monkey["inspections"]
    -- print(insp)
    if insp > top_inspectors[1] then
        top_inspectors[2] = top_inspectors[1]
        top_inspectors[1] = insp
    elseif insp > top_inspectors[2] then
        top_inspectors[2] = insp
    end
    -- print(insp .. ' ' .. top_inspectors[1] .. ' ' .. top_inspectors[2])
end

-- print(top_inspectors[1])
-- print(top_inspectors[2])
print('Solution: ' .. top_inspectors[1] * top_inspectors[2])