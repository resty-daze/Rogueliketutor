require "objects"

Player = Entity:extend()

function Player:new(normal_state, x, y)
    Player.super.new(self, x, y, "@", {1, 0.7, 0.5})
    self.normal_state = normal_state
end

function Player:keypressed(key)
    local nx = self.x
    local ny = self.y

    if key == "up" then
        ny = ny - 1
    elseif key == "down" then
        ny = ny + 1
    elseif key == "left" then
        nx = nx - 1
    elseif key == "right" then
        nx = nx + 1
    end

    local map = self.normal_state.map
    if map:out_range(nx, ny) then
        return
    end

    local tile = map:get_tile(nx, ny)
    if tile.block_move then
        return
    end
    self.x = nx
    self.y = ny
end

return Player