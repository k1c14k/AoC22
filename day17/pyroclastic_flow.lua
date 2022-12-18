TEST_INPUT_FILE_NAME = 'day17/inputT.txt'
PROD_INPUT_FILE_NAME = 'day17/input.txt'


Pattern = { idx = 0 }


function Pattern:new(pattern)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.pattern = pattern
    return o
end


function Pattern:next()
    self.idx = self.idx + 1
    pos = ((self.idx - 1) % #self.pattern) + 1
    return self.pattern:sub(pos, pos)
end


Board = {
    width = 7
}


function Board:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.points = {}
    return o
end


function Board:max_y()
    return #self.points
end

function Board:get_point(x, y)
    if self.points[y] == nil then
        return 0
    else
        return self.points[y][x]
    end
end


function Board:move(block, x, y)
    for _, p in pairs(block.shape) do
        px, py = p.x + x, p.y + y
        -- print(px, py)
        if px < 1 or px > self.width or py < 1 or self:get_point(px, py) == 1 then
            return false
        end
    end
    for _, p in pairs(block.shape) do
        p.x, p.y = p.x + x, p.y + y
    end
    return true
end


function Board:set_point(x, y)
    if y > #self.points then
        for i = #self.points + 1, y do
            self.points[i] = {}
            for j = 1, self.width do
                self.points[i][j] = 0
            end
        end
    end
    self.points[y][x] = 1
end


function Board:write(block)
    for _, p in pairs(block.shape) do
        self:set_point(p.x, p.y)
    end
end


Block = {
    shapes = {
        {
            { x = 0, y = 0 },
            { x = 1, y = 0 },
            { x = 2, y = 0 },
            { x = 3, y = 0 }
        },
        {
            { x = 1, y = 0 },
            { x = 0, y = 1 },
            { x = 1, y = 1 },
            { x = 2, y = 1 },
            { x = 1, y = 2 }
        },
        {
            { x = 0, y = 0 },
            { x = 1, y = 0 },
            { x = 2, y = 0 },
            { x = 2, y = 1 },
            { x = 2, y = 2 }
        },
        {
            { x = 0, y = 0 },
            { x = 0, y = 1 },
            { x = 0, y = 2 },
            { x = 0, y = 3 }
        },
        {
            { x = 0, y = 0 },
            { x = 1, y = 0 },
            { x = 0, y = 1 },
            { x = 1, y = 1 }
        }
    }
}


function Block:new(shape, y)
    o = {}
    setmetatable(o, self)
    self.__index = self
    shape = ((shape - 1) % #self.shapes) + 1
    o.shape = {}
    for _, p in pairs(self.shapes[shape]) do
        o.shape[#o.shape + 1] = { x = p.x + 3, y = p.y + y }
    end
    return o
end


function solve(file_name, rocks)
    io.input(file_name)
    local pattern = Pattern:new(io.read("*line"))
    local board = Board:new()
    for i = 1, rocks do
        local block = Block:new(i, board:max_y() + 4)
        repeat
            if pattern:next() == '<' then
                board:move(block, -1, 0)
            else
                board:move(block, 1, 0)
            end
        until not board:move(block, 0, -1)
        board:write(block)
    end
    return board:max_y()
end


print('Solution: ' .. solve(TEST_INPUT_FILE_NAME, 2022))
-- print('Solution: ' .. solve(TEST_INPUT_FILE_NAME, 1000000000000))
