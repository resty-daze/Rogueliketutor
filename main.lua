local term = require "term"

local px = 40
local py = 16
function love.load()
    char_size = 16
    font_name = "data/AnonymousProMinus-1.003/Anonymous Pro Minus.ttf"
    font = love.graphics.newFont(font_name, char_size)
    term.init(80, 32, font)
    love.window.setMode(term.width * term.char_width, term.height * term.char_height)
    term.board[py][px][1] = '@'
end

function love.draw()
    term.render()
end

local clamp = function(x, a, b)
    if x < a then
        return a
    elseif x > b then
        return b
    end
    return x
end

function love.keypressed( key, scancode, isrepeat ) 
    term.board[py][px][1] = ' '
    if key == 'up' then
        py = py - 1
    elseif key == 'down' then
        py = py + 1
    elseif key == 'left' then
        px = px - 1
    elseif key == 'right' then
        px = px + 1
    end
    px = clamp(px, 1, 80)
    py = clamp(py, 1, 32)
    term.board[py][px][1] = '@'
end