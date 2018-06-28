-- calculate field of view
local Tiles = require "tiles"

local dx = {0, -1, 0, 1}
local dy = {-1, 0, 1, 0}

local function dist_sqr(pos1, pos2)
    local dx = pos1[1] - pos2[1]
    local dy = pos1[2] - pos2[2]
    return dx * dx + dy * dy
end

local function mandist(pos1, pos2)
    return math.abs(pos1[1] - pos2[1]) + math.abs(pos1[2] - pos2[2])
end

local fov = {}
function fov.field_of_view(map, stand_point)
    local visit = {}
    for i = 1, map.height do
        local row = {}
        visit[i] = row
        for j = 1, map.width do
            row[j] = false
        end
    end

    local in_room = (map:get_tile(stand_point[1], stand_point[2]) == Tiles.room_floor)

    local queue = {{stand_point, 0}}
    visit[stand_point[2]][stand_point[1]] = true
    local f = 1
    while f <= #queue do
        local pos = queue[f][1]
        local dist = queue[f][2]
        local tile = map:get_tile(pos[1], pos[2])
        if (in_room and tile == Tiles.room_floor) or 
            (not tile.block_sight and dist_sqr(stand_point, pos) <= 9 and dist == mandist(stand_point, pos)) then
            for i = 1, 4 do
                local new_pos = {pos[1] + dx[i], pos[2] + dy[i]}
                if not map:out_range(unpack(new_pos)) and not visit[new_pos[2]][new_pos[1]] then
                    visit[new_pos[2]][new_pos[1]] = true
                    queue[#queue + 1] = {new_pos, dist + 1}
                end
            end
        end
        f = f + 1
    end

    return visit
end

return fov