-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("remember_last_location", { clear = true }),
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    desc = "Detect uv-driven scripts as Python",
    group = vim.api.nvim_create_augroup("detect_uv_python_shebang", { clear = true }),
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]
        if not first_line or not first_line:match("^#!") then
            return
        end

        local shebang = first_line:gsub("^#!%s*", "")
        local tokens = {}
        for token in shebang:gmatch("%S+") do
            tokens[#tokens + 1] = token
        end

        local idx = 1
        local function skip_assignments()
            while tokens[idx] and tokens[idx]:match("^[%a_][%w_]*=") do
                idx = idx + 1
            end
        end

        skip_assignments()

        local first = tokens[idx]
        if first and first:lower():match("env$") then
            idx = idx + 1
            while tokens[idx] do
                local value = tokens[idx]
                local lower = value:lower()
                if lower == "-s" or lower == "--split-string" then
                    idx = idx + 1
                    break
                elseif lower:sub(1, 1) == "-" then
                    idx = idx + 1
                elseif value:match("^[%a_][%w_]*=") then
                    idx = idx + 1
                else
                    break
                end
            end
            skip_assignments()
        end

        skip_assignments()

        local command = tokens[idx]
        if not command then
            return
        end

        command = (command:match("([^/]+)$") or command):lower()
        if command ~= "uv" then
            return
        end

        vim.bo[args.buf].filetype = "python"
    end,
})
