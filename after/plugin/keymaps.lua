local setkey = require('utils').setkey
local Snacks = require("snacks")
local picker = Snacks.picker

-- Simple windows navigation, same set in tmux
setkey("n", "<c-h>", "<c-w><c-h>", "Switch split left")
setkey("n", "<c-j>", "<c-w><c-j>", "Switch split down")
setkey("n", "<c-k>", "<c-w><c-k>", "Switch split up")
setkey("n", "<c-l>", "<c-w><c-l>", "Switch split right")

-- Utilities
setkey("n", "<C-/>", function() if vim.opt.hlsearch then vim.cmd.nohl() end end, "Toggle of hlsearch")

-- Files search <leaders>s...
setkey("n", "<leader>sf", picker.files, "Search files")
setkey("n", "<leader>sb", picker.buffers, "Search buffers")
setkey("n", "<leader>sg", picker.git_grep, "Search live git grep")
setkey("n", "<leader>sG", picker.grep, "Search live ripgrep")
setkey("n", "<leader>s*", picker.grep_word, "Grep string under cursor")
setkey("n", "<leader>sr", picker.resume, "Resume last search")
setkey("n", "<leader>sn", picker.notifications, "Search notifications")

-- Find some elements <leader>f...
setkey("n", "<Leader>fk", picker.keymaps, "Find keymaps")
setkey("n", "<Leader>fc", picker.commands, "Find commands")
setkey("n", "<leader>fs", picker.spelling, "Find spelling")

-- Toggles <leader>t...
setkey("n", "<leader>tD", function()
        if vim.diagnostic.is_enabled() then
            vim.diagnostic.enable(false)
            vim.notify("[toggle] Diagnostics disabled")
        else
            vim.diagnostic.enable(true)
            vim.notify("[toggle] Diagnostics enabled")
        end
    end,
    "Toggle Diagnostics"
)
setkey("n", "<leader>td", function()
        local current_value = vim.diagnostic.config().virtual_text
        if current_value then
            vim.diagnostic.config { virftual_text = false }
            vim.notify("[toggle] Virtual diagnostic disabled")
        else
            vim.diagnostic.config { virftual_text = true }
            vim.notify("[toggle] Virtual diagnostic disabled")
        end
    end,
    "Toggle Virtual diagnostics"
)
setkey("n", "<leader>tm", function()
        vim.o.scrollof = 9999 - vim.o.scrollof
    end,
    "Toggle middle line focus"
)

-- ## Common operations
-- spawn cmd p1 p1 -> spawn "cmd" "p1" "p2"
-- Quote every word after the first on each selected line
-- Put this in your init.lua (or a sourced Lua file)
vim.keymap.set("v", "<leader>rq", function()
    -- get visual range (1-based rows, 0-based cols)
    local buf = 0
    local srow, scol = unpack(vim.api.nvim_buf_get_mark(buf, "<"))
    local erow, ecol = unpack(vim.api.nvim_buf_get_mark(buf, ">"))

    -- normalize to 0-based row indices for nvim_buf_get_lines/set_lines
    srow, erow = srow - 1, erow - 1

    local lines = vim.api.nvim_buf_get_lines(buf, srow, erow + 1, false)
    for i, line in ipairs(lines) do
        -- keep leading indentation
        local indent, rest = line:match("^(%s*)(.*)$")
        rest = rest or ""

        -- split remaining part into words by whitespace
        local words = vim.split(vim.trim(rest), "%s+", { trimempty = true })

        if #words >= 2 then
            local first = words[1]
            local quoted = {}
            for j = 2, #words do
                quoted[#quoted + 1] = string.format('"%s"', words[j])
            end
            lines[i] = indent .. first .. " " .. table.concat(quoted, " ")
        else
            -- 0 or 1 word -> leave as is
            lines[i] = line
        end
    end

    vim.api.nvim_buf_set_lines(buf, srow, erow + 1, false, lines)

    -- reselect previous visual area (handy if you want to run it again)
    vim.cmd("normal! gv")
end, { desc = "Quote all but the first word on each selected line" })

vim.keymap.set("t", "<Esc>", '<C-\\><C-n>', { desc = "Exit terminal mode" })
