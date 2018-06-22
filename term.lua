-- a simple emu terminal

local term = {}
local board = {}

function term.init(width, height, font, char_height, char_width)
    term.width = width
    term.height = height
    term.font = font
    term.background_color = {0, 0, 0}
    term.board = board

    if not char_height then
        char_height = font:getHeight()
    end
    term.char_height = char_height

    if not char_width then
        char_width = font:getWidth("@") + 2
    end
    term.char_width = char_width

    for i = 1, term.height do
        board[i] = {}
        for j = 1, term.width do
            -- character, char color, background color
            board[i][j] = {" ", {255, 255, 255}, {0, 0, 0}}
        end
    end 
end

function term.update()
end

function term.render()
    love.graphics.setFont(term.font)
    love.graphics.clear(unpack(term.background_color))
    for i = 1, term.height do
        for j = 1, term.width do
            x = (j - 1) * term.char_width
            y = (i - 1) * term.char_height
            love.graphics.setColor(unpack(board[i][j][3]))
            love.graphics.rectangle("fill", x, y, term.char_width, term.char_height)
            
            love.graphics.setColor(unpack(board[i][j][2]))
            love.graphics.print(board[i][j][1], x, y)
        end
    end
end

return term