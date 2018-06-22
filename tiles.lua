require "objects"
local black = {0, 0, 0}
local white = {1, 1, 1}
local grey = {0.5, 0.5, 0.5}

-- char, color, block_sight, block_move, block_fly
local tiles = {
    void = Tile(" ", black, true, true, true),
    wall_vert = Tile("|", white, true, true, true),
    wall_hori = Tile("-", white, true, true, true),
    wall_corn = Tile("+", white, true, true, true),
    room_floor = Tile(".", grey, false, false, false),
    passage = Tile("#", grey, false, false, false),
}

return tiles