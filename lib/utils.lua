local utils = {}
function utils.clamp(x, a, b)
    if x < a then
        return a
    elseif x > b then
        return b
    end
    return x
end

return utils