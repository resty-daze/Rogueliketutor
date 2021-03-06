local Object = require "lib/classic"
local term = require "term"
local fov = require "fov"
local utils = require "lib/utils"

local Map = Object:extend()

function Map:new(width, height, default_tile)
    self.width = width
    self.height = height
    self.tiles = utils.table2d(height, width, default_tile)
    self.seen = utils.table2d(height, width, false)
    
    self.spawn_pos = {math.floor(self.width / 2), math.floor(self.height / 2)}
    self.units = {} -- non player units
end

function Map:add_unit(u)
    self.units[#self.units + 1] = u
end

function Map:find_unit_at(x, y)
    for _, u in ipairs(self.units) do
        if u.x == x and u.y == y then
            return u
        end
    end
    return nil
end

function Map:out_range(x, y)
    return x < 1 or x > self.width or y < 1 or y > self.height
end

function Map:set_tile(x, y, tile)
    self.tiles[y][x] = tile
end

function Map:get_tile(x, y)
    return self.tiles[y][x]
end

function Map:render()
    for i = 1, self.height do
        for j = 1, self.width do
            if self.fov[i][j] then
                local tile = self.tiles[i][j]
                term.setchar(j, i, tile.char, tile.color)
            elseif self.seen[i][j] then
                local tile = self.tiles[i][j]
                local rate = 0.5
                local darker_color = {tile.color[1] * rate, tile.color[2] * rate, tile.color[3] * rate}
                term.setchar(j, i, tile.char, darker_color)
            end
        end
    end

    for _, u in ipairs(self.units) do
        if self.fov[u.y][u.x] then
            term.setchar(u.x, u.y, u.char, u.color)
        end
    end
end

function Map:update_fov(player_x, player_y)
    self.fov = fov.field_of_view(self, {player_x, player_y})
    for i = 1, self.height do
        for j = 1, self.width do
            self.seen[i][j] = self.seen[i][j] or self.fov[i][j]
        end
    end
end

return Map