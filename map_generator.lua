local Map = require "map"
local Object = require "lib/classic"
local Tiles = require "tiles"
local utils = require "lib/utils"

local generators = {}
local next = next

local function room_conflict(r1, r2)
    if r1[1] + r1[3] < r2[1] or r1[1] > r2[1] + r2[3] then
        return false
    end 
    if r1[2] + r1[4] < r2[2] or r1[2] > r2[2] + r2[4] then
        return false
    end
    return true
end

local function add_room(map, room)
    for i = room[1], room[1] + room[3] - 1 do
        for j = room[2], room[2] + room[4] - 1 do
            local v = false
            local h = false
            if i == room[1] or i == room[1] + room[3] - 1 then
                v = true
            end
            if j == room[2] or j == room[2] + room[4] - 1 then
                h = true
            end

            if v and h then
                map:set_tile(i, j, Tiles.wall_corn)
            elseif v then
                map:set_tile(i, j, Tiles.wall_vert)
            elseif h then
                map:set_tile(i, j, Tiles.wall_hori)
            else
                map:set_tile(i, j, Tiles.room_floor)
            end 
        end
    end
end

local function open_door(map, room)
    local opened_doors = {}
    local new_doors = {}

    local function process_pos(wall_pos, outer_pos)
        if map:out_range(outer_pos[1], outer_pos[2]) then
            return
        end

        local wall_tile = map:get_tile(wall_pos[1], wall_pos[2])
        local outer_tile = map:get_tile(outer_pos[1], outer_pos[2])
        if outer_tile ~= Tiles.void and outer_tile ~= Tiles.road then
            return
        end

        if wall_tile.block_move then
            -- still wall
            new_doors[#new_doors + 1] = {wall_pos, outer_pos}
        else
            -- already door here
            opened_doors[#opened_doors + 1] = {wall_pos, outer_pos}
        end
    end

    local function add_door(map, pos)
        map:set_tile(pos[1], pos[2], Tiles.room_floor)
    end

    -- add all slots
    for x = room[1] + 1, room[1] + room[3] - 2 do
        process_pos({x, room[2]}, {x, room[2] - 1})
        process_pos({x, room[2] + room[4] - 1}, {x, room[2] + room[4]})
    end

    for y = room[2] + 1, room[2] + room[4] - 2 do
        process_pos({room[1], y}, {room[1] - 1, y})
        process_pos({room[1] + room[3] - 1, y}, {room[1] + room[3], y})
    end

    -- random choice a result
    if #opened_doors > 0 and (#opened_doors > 3 or love.math.random() < 0.6) then
        local selected = opened_doors[love.math.random(1, #opened_doors)]
        return selected[2]
    else
        -- need open new door
        assert(next(new_doors) ~= nil)
        local selected = new_doors[love.math.random(1, #new_doors)]
        add_door(map, selected[1])
        return selected[2]
    end
end

local dx = {0, -1, 0, 1}
local dy = {-1, 0, 1, 0}
local function connect_room(map, start_pos, end_pos)
    local queue = {{start_pos, 0}}
    local visit = utils.table2d(map.height, map.width, false)
    local f = 1
    
    visit[start_pos[2]][start_pos[1]] = true

    -- bfs for shorest path
    local find = false
    while f <= #queue and not find do
        local current_pos = queue[f][1]
        for i = 1, 4 do
            local new_pos = {current_pos[1] + dx[i], current_pos[2] + dy[i]}
            if map:out_range(new_pos[1], new_pos[2]) or visit[new_pos[2]][new_pos[1]] then
                -- continue
            else
                local tile = map:get_tile(new_pos[1], new_pos[2])
                if tile == Tiles.void or tile == Tiles.road then
                    visit[new_pos[2]][new_pos[1]] = true
                    queue[#queue + 1] = {new_pos, f}
                    if new_pos[1] == end_pos[1] and new_pos[2] == end_pos[2] then
                        find = true
                        break
                    end
                end
            end
        end

        f = f + 1
    end
    -- should find path
    assert(find)

    -- fill path with road tile
    local current_id = #queue
    while current_id > 0 do
        local pos = queue[current_id][1]
        current_id = queue[current_id][2]
        map:set_tile(pos[1], pos[2], Tiles.road)
    end
end

-- add roads to connect all rooms
local function add_roads(map, rooms)
    local n = #rooms
    -- connect each room to a random previous room
    for i = 2, n do
        local dest_room_id = love.math.random(1, i - 1)
        local start_pos = open_door(map, rooms[i])
        local end_pos = open_door(map, rooms[dest_room_id])
        connect_room(map, start_pos, end_pos)
    end
end

local function try_generate(width, height)
    local rooms = {}
    for i = 1, 30 do
        local rwidth = love.math.random(4, 16)
        local rheight = love.math.random(4, 10)
        local x = love.math.random(1, width - rwidth)
        local y = love.math.random(1, height - rheight)
        local room = {x, y, rwidth, rheight}
        local no_conflict = true
        for _, r in ipairs(rooms) do
            if room_conflict(r, room) then
                no_conflict = false
                break
            end
        end

        if no_conflict then
            rooms[#rooms + 1] = room
        end
    end

    if #rooms <= 8 or #rooms >= 16 then
        return nil
    end
    
    local map = Map(width, height, Tiles.void)
    for _, r in ipairs(rooms) do
        add_room(map, r)
    end
    
    add_roads(map, rooms)
    local spawn_room = rooms[love.math.random(1, #rooms)]
    map.spawn_pos = { love.math.random(spawn_room[1] + 1, spawn_room[1] + spawn_room[3] - 2),
                      love.math.random(spawn_room[2] + 1, spawn_room[2] + spawn_room[4] - 2) }
                      
    return map
end

function generators.room_map(width, height)
    local generated_room
    repeat
        generated_room = try_generate(width, height)
    until generated_room
    return generated_room
end

return generators