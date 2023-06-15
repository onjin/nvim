local M = {}

M.indexOf = function(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

M.tablelength = function(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

return M
