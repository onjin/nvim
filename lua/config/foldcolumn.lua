-- The `foldinner` is not yet in 0.11, and the numbers at left are annoying
-- So use custom statuscolumn to show max 2 levels
local MAX_DEPTH = 2

local M = {}

local icons = {
    mid = "│",
    open = "",
    closed = "",
    empty = " ",
}


local function is_fold_closed_start(lnum)
    local closed_at = vim.fn.foldclosed(lnum)
    return closed_at ~= -1 and closed_at == lnum
end

local function is_fold_start(lnum, level)
    if lnum <= 1 then
        return level > 0
    end
    return level > vim.fn.foldlevel(lnum - 1)
end

local function format_number()
    if vim.v.virtnum ~= 0 then
        return string.rep(" ", vim.wo.numberwidth)
    end

    local show_number = vim.wo.number
    local show_rel = vim.wo.relativenumber
    if not show_number and not show_rel then
        return string.rep(" ", vim.wo.numberwidth)
    end

    local rel = vim.v.relnum
    local value
    if show_rel and rel > 0 then
        value = rel
    else
        value = vim.v.lnum
    end

    return string.format("%" .. vim.wo.numberwidth .. "d", value)
end

---Expose line number segment for statuscolumn.
---@return string
function M.number()
    return format_number()
end

---Render custom fold column glyphs limited to MAX_DEPTH levels.
---@return string
function M.render()
    local lnum = vim.v.lnum
    local level = vim.fn.foldlevel(lnum)

    if level <= 0 then
        return icons.empty:rep(MAX_DEPTH)
    end

    local cols = {}

    for depth = 1, MAX_DEPTH - 1 do
        if depth < level then
            table.insert(cols, icons.mid)
        else
            table.insert(cols, icons.empty)
        end
    end

    if level > MAX_DEPTH then
        table.insert(cols, icons.empty)
    else
        local glyph
        if is_fold_closed_start(lnum) then
            glyph = icons.closed
        elseif is_fold_start(lnum, level) then
            glyph = icons.open
        elseif level > MAX_DEPTH - 1 then
            glyph = icons.mid
        else
            glyph = icons.empty
        end
        table.insert(cols, glyph)
    end

    return table.concat(cols)
end

return M
