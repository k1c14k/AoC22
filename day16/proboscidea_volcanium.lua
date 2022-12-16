TEST_INPUT_FILE_NAME = 'day16/inputT.txt'
PROD_INPUT_FILE_NAME = 'day16/input.txt'


function create_valve(name, rate, connections)
    return {
        ["name"] = name,
        ["rate"] = tonumber(rate),
        ["connections"] = connections
        }
end


function read_input(file_name)
    local result = {}
    for line in io.lines(file_name) do
        valve, rate, _, _, _, connections = line:match('Valve (%a+) has flow rate=(%d+); tunnel(s?) lead(s?) to valve(s?) (.+)')
        edges = {}
        while connections ~= nil do
            edge, _, connections = connections:match('(%a+)(,? ?)(.*)')
            -- print(edge, _, connections)
            edges[#edges + 1] = edge
        end
        -- print(valve, rate, connections, #edges)
        result[valve] = create_valve(valve, rate, edges)
    end
    for _, valve in pairs(result) do
        for i=1, #valve.connections do
            valve.connections[i] = result[valve.connections[i]]
        end
    end
    return result
end


function create_state(valve, remaining_time, flow, opened_valves, opened_valves_count, moves_made)
    return {
        ["valve"] = valve,
        ["remaining_time"] = remaining_time,
        ["flow"] = flow,
        ["opened_valves"] = opened_valves,
        ["opened_valves_count"] = opened_valves_count,
        ["moves_made"] = moves_made
        }
end


function no_pressure_valves(valves)
    local result = {}
    for name, valve in pairs(valves) do
        if valve.rate == 0 then
            result[name] = 1
        end
    end
    return result
end


function copy_and_set(opened_valves, valve_name)
    local result = {}
    for k, _ in pairs(opened_valves) do
        result[k] = 1
    end
    result[valve_name] = 1
    return result
end


function map_size(map)
    local result = 0
    for _, _ in pairs(map) do
        result = result + 1
    end
    return result
end


function copy_and_extend(t, v)
    local result = {}
    for i=1, #t do
        result[i] = t[i]
    end
    result[#result + 1] = v
    return result
end


function find_paths(valves, opened_valves, valve)
    local paths = {{valve.name}}
    local visited = {[valve.name] = 1}
    local i = 0
    while i < #paths do
        i = i + 1
        local working = paths[i]
        for _, connection in pairs(valves[working[#working]].connections) do
            if visited[connection.name] == nil then
                visited[connection.name] = 1
                paths[#paths + 1] = copy_and_extend(working, connection.name)
            end
        end
    end

    local result = {}
    for _, p in pairs(paths) do
        if opened_valves[p[#p]] == nil and p[#p] ~= valve.name then
            result[#result + 1] = p
        end
    end
    return result
end


function make_move(Q, best_result, valve_count)
    local working = table.remove(Q)
    local remaining_time = working.remaining_time
    local opened_valves_count = working.opened_valves_count
    local flow = working.flow
    -- print(remaining_time)
    -- print('Worker flow ' .. flow)
    if remaining_time == 0 or opened_valves_count == valve_count then
        -- print('Worker exits with flow ' .. flow)
        if flow > best_result then
            return flow
        else
            return best_result
        end
    end
    remaining_time = remaining_time - 1
    local valve = working.valve
    local valve_name = valve.name
    local opened_valves = working.opened_valves
    local moves_made = working.moves_made
    if opened_valves[valve_name] == nil then
        -- print('Worker opens valve ' .. valve.name)
        Q[#Q + 1] = create_state(valve, remaining_time, flow + valve.rate * remaining_time, copy_and_set(opened_valves, valve_name), opened_valves_count + 1, moves_made)
        return best_result
    end
    local paths_to_not_opened_valves = find_paths(valves, opened_valves, valve)
    for _, path in pairs(paths_to_not_opened_valves) do
        -- local route = valve_name .. '-' .. path[#path]
        local destination = path[#path]
        if moves_made[destination] == nil and remaining_time - #path +2 >= 0 then
            -- print('Worker heads to ' .. destination)
            Q[#Q + 1] = create_state(valves[destination], remaining_time - #path + 2, flow, opened_valves, opened_valves_count, copy_and_set(moves_made, destination))
        end
    end
    -- for _, connection in pairs(valve.connections) do
    --  local path = valve_name .. '-' .. connection.name
    --  if moves_made[path] == nil then
    --      Q[#Q + 1] = create_state(connection, remaining_time, flow, opened_valves, opened_valves_count, copy_and_set(moves_made, path))
    --  end
    -- end
    -- Q[#Q+1] = create_state(valve, remaining_time, flow, opened_valves, opened_valves_count, moves_made)
    -- print(remaining_time)
    if flow > best_result then
        return flow
    else
        return best_result
    end
end


function find_max_flow(valves, initial_time, workers)
    local best_result = -1
    local valve_count = map_size(valves)
    local no_pressure = no_pressure_valves(valves)
    local Q={}
    Q[1] = {}
    for i=1, workers do
        Q[1][i] = create_state(valves['AA'], initial_time, 0, no_pressure, map_size(no_pressure), {})
    end
    while #Q > 0 do
        -- best_result = make_move(Q, best_result, valve_count)
        -- print(#Q, best_result)
        local next_move = table.remove(Q)
        local next_worker = 1
        for i=2, #next_move do
            if next_move[i].remaining_time > next_move[next_worker].remaining_time then
                next_worker = i
            end
        end
        -- print('Using worker ' .. next_worker .. ' / ' .. #next_move)
        local worker_state = {next_move[next_worker]}
        table.remove(next_move, next_worker)
        best_result = make_move(worker_state, best_result, valve_count)
        if #worker_state > 0 then
            for _, q in pairs(worker_state) do
                local next_q = copy_and_extend(next_move, q)
                for _, state in pairs(next_q) do
                    state.moves_made = q.moves_made
                    state.opened_valves = q.opened_valves
                    state.flow = q.flow
                end
                Q[#Q + 1] = next_q
            end
        elseif #next_move > 0 then
            Q[#Q + 1] = next_move
        end
    end
    return best_result
end


function solve(file_name, initial_time, workers)
    valves = read_input(file_name)
    return find_max_flow(valves, initial_time, workers)
end


solution = solve(TEST_INPUT_FILE_NAME, 30, 1)
print('Solution: ' .. solution)