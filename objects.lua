local Object = require "lib/classic"

Entity = Object:extend()

function Entity:new(x, y, char, color)
    self.x = x
    self.y = y
    self.char = char
    self.color = color
end

function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

-- Tile
Tile = Object:extend()

function Tile:new(char, color, block_sight, block_move, block_fly)
    self.char = char
    self.color = color
    self.block_sight = block_sight
    self.block_move = block_move
    self.block_fly = block_fly
end