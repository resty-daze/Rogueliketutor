local Object = require "lib/classic"
local term = require "term"

local Map = Object:extend()

function Map:new(width, height, default_tile)
    self.width = width
    self.height = height
    self.tiles = {}
    for i = 1, height do
        self.tiles[i] = {}
        for j = 1, width do
            self.tiles[i][j] = default_tile
        end
    end
    
    self.spawn_pos = {math.floor(self.width / 2), math.floor(self.height / 2)}
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
            local tile = self.tiles[i][j]
            term.setchar(j, i, tile.char, tile.color)
        end
    end
end

return Map