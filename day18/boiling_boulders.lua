TEST_INPUT_FILE = 'day18/inputT2.txt'
PROD_INPUT_FILE = 'day18/input.txt'


Block = {x = 0, y = 0, z = 0, sides = 6}


function Block:new(x, y, z)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.z = z
    o.sides = self.sides
    return o
end


function solve(file_name)
    blocks = {}
    checked_sides = {
        {-1, 0, 0},
        {1, 0, 0},
        {0, -1, 0},
        {0, 1, 0},
        {0, 0, -1},
        {0, 0, 1},
    }
    for ln in io.lines(file_name) do
        xn, yn, zn = ln:match('(%d+),(%d+),(%d+)')
        block = Block:new(xn, yn, zn)
        for _, checked_side in pairs(checked_sides) do
            x, y, z = xn + checked_side[1], yn + checked_side[2], zn + checked_side[3]
            local k = x .. ',' .. y .. ',' .. z
            local touching = blocks[k]
            if touching ~= nil then
                touching.sides = touching.sides - 1
                block.sides = block.sides - 1
            end
        end
        blocks[xn .. ',' .. yn .. ',' .. zn] = block
    end
    local result = 0
    for _, b in pairs(blocks) do
        -- print(b.sides)
        result = result + b.sides
    end
    return result
end


print('Soultion: ' .. solve(PROD_INPUT_FILE))