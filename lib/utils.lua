local utils = {}
function utils.clamp(x, a, b)
    if x < a then
        return a
    elseif x > b then
        return b
    end
    return x
end

function utils.table2d(rows, cols, value)
    local t = {}
    for i = 1, rows do
        local r = {}
        t[i] = r
        for j = 1, cols do
            r[j] = value
        end
    end
    return t
end

return utils