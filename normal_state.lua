local Object = require "lib/classic"
local term = require "term"
local Player = require "player"
local Map = require "map"
local Tiles = require "tiles"

NormalState = Object:extend()

function NormalState:new()
    self.entity_list = {}
    self.map = Map(MAP_WIDTH, MAP_HEIGHT, Tiles.room_floor)
    self.player = Player(self, 20, 20)
    self:add_entity(self.player)
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