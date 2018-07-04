-- a console to print logs

local Object = require('lib/classic')
local term = require('term')

local Console = Object:extend()

function Console:new(x, y, height, width)
    self.x = x
    self.y = y
    self.height = height
    self.width = width
    self.logs = {}
end

function Console:print(fmt, ...)
    self.logs[#self.logs + 1] = string.format(fmt, unpack(arg))
end

function Console:_calc_len(s)
    return math.ceil(#s / self.width)
end

function Console:render()
    if next(self.logs) == nil then
        return
    end

    local last = #self.logs
    local first = last
    local len = self:_calc_len(self.logs[first])
    while first > 1 do
        local next_len = self:_calc_len(self.logs[first - 1])
        if next_len + len > self.height then
            break
        end
        first = first - 1
        len = next_len + len
    end

    local x = self.x
    local y = self.y
    for i = first, last do
        for ch in self.logs[i]:gmatch(".") do
            term.setchar(x, y, ch, term.white)
            x = x + 1
            if x == self.x + self.width then
                x = self.x
                y = y + 1
            end
        end
        if x ~= self.x then
            y = y + 1
            x = self.x
        end
    end
end

function Console:render_fullscreen()
    -- not used now
end

return Console