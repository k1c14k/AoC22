cwd = {}
fs = {
    ["dirs"] = {},
    ["files"] ={},
    ["size"] = 0
    }

function get_dir(wd)
    dir = fs
    for _, dir_name in pairs(cwd) do
        dir = dir["dirs"][dir_name]
    end

    return dir
end

function change_create_dir(argument)
    dir = get_dir(cwd)

    if dir["dirs"][argument] == nil then
        dir["dirs"][argument] = {
            ["dirs"] = {},
            ["files"] ={},
            ["size"] = 0
            }
        end

    cwd[#cwd + 1] = argument
end

function process_command_cd(argument)
    if argument == '/' then
        cwd = {}
    elseif argument == '..' then
        cwd[#cwd] = nil
    else
        change_create_dir(argument)
    end
end

function process_command(line)
    command, argument = line:match('[$] (%a+) (.+)')
    if command == 'cd' then
        process_command_cd(argument)
    end
end

function create_file(file_name, file_size)
    dir = get_dir(cwd)
    dir["files"][file_name] = file_size
end

function process_file_size(line)
    file_size, file_name = line:match('(%d+) (.+)')
    file_size = tonumber(file_size)
    create_file(file_name, file_size)
end

function process_dir(line)
    dir_name = line:match('dir (.+)')
end

function process_size(line)
    first_char = line:sub(1,1)
    if first_char == 'd' then
        process_dir(line)
    else
        process_file_size(line)
    end
end

function process(line)
    first_char = line:sub(1,1)
    if first_char == '$' then
        process_command(line)
    else
        process_size(line)
    end
end

for line in io.lines('day7/input.txt') do
    process(line)
end

puzzle_result = 0

function update_dir_sizes(dir)
    result = 0

    for _, subdir in pairs(dir["dirs"]) do
        result = result + update_dir_sizes(subdir)
    end

    for _, file in pairs(dir["files"]) do
        result = result + file
    end

    dir["size"] = result

    if result <= 100000 then
        puzzle_result = puzzle_result + result
    end

    return result
end

used_space = update_dir_sizes(fs)

function print_dir(dir, dir_name, level)
    if dir_name == nil then
        dir_name = '/'
    end

    if level == nil then
        level = 0
    end

    indent = ''

    for _=1, level do
        indent = indent .. '  '
    end

    print(indent .. '- ' .. dir_name .. ' (dir) size: ' .. dir["size"])

    for file_name, file_size in pairs(dir["files"]) do
        print(indent .. '  - ' .. file_name .. ' size: ' .. file_size)
    end

    for name, child_dir in pairs(dir["dirs"]) do
        print_dir(child_dir, name, level + 1)
    end
end

print_dir(fs)

print('puzzle result 1 = ' .. puzzle_result)

disk_capacity = 70000000
needed_space = 30000000
minimal_candidate = needed_space - (disk_capacity - used_space)
delete_candidate = disk_capacity

function find_delete_candidate(dir)
    if dir["size"] >= minimal_candidate and dir["size"] < delete_candidate then
        delete_candidate = dir["size"]
    end

    for _, subdir in pairs(dir["dirs"]) do
        find_delete_candidate(subdir)
    end
end
find_delete_candidate(fs)

print('puzzle result 2 = ' .. delete_candidate)