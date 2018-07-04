local term = require "term"
local Console = require "console"
require "objects"
require "normal_state"
utils = require "lib/utils"

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    normal_state = NormalState()
    current_state = normal_state
    
    char_size = 16
    font_name = "data/AnonymousProMinus-1.003/Anonymous Pro Minus.ttf"
    font = love.graphics.newFont(font_name, char_size)
    term.init(90, 40, font)
    love.window.setMode(term.width * term.char_width, term.height * term.char_height)
    console = Console(1, 33, 8, 80)
end

function love.draw()
    term.clear()
    current_state:render()
    term.render()
end

function love.keypressed( key, scancode, isrepeat ) 
    return current_state:keypressed(key)
end