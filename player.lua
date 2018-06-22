require "objects"

Player = Entity:extend()

function Player:new(normal_state, x, y)
    Player.super.new(self, x, y, "@", {1, 0.7, 0.5})
    self.normal_state = normal_state
end

function Player:keypressed(key)
    if key == "up" then
        self.y = self.y -1
    elseif key == "down" then
        self.y = self.y + 1
    elseif key == "left" then
        self.x = self.x - 1
    elseif key == "right" then
        self.x = self.x + 1
    end

    self.x = utils.clamp(self.x, 1, MAP_WIDTH)
    self.y = utils.clamp(self.y, 1, MAP_HEIGHT)
end

return Player