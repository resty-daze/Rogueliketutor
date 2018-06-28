local Object = require "lib/classic"
local term = require "term"
local Player = require "player"
local Map = require "map"
local Generators = require "map_generator"

NormalState = Object:extend()

function NormalState:new()
    self.entity_list = {}
    self.map = Generators.room_map(MAP_WIDTH, MAP_HEIGHT)
    self.player = Player(self, self.map.spawn_pos[1], self.map.spawn_pos[2])
    self:add_entity(self.player)
    self.map:update_fov(self.player.x, self.player.y)
end

function NormalState:add_entity(entity)
    self.entity_list[#self.entity_list + 1] = entity
end

function NormalState:keypressed(key)
    self.player:keypressed(key)
end

function NormalState:render()
    self.map:render()
    for _, entity in ipairs(self.entity_list) do
        --print(entity)
        term.setchar(entity.x, entity.y, entity.char, entity.color)
    end
end