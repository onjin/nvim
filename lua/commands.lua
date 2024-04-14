-- luacheck: globals vim
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local user_command = vim.api.nvim_create_user_command

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "1000" })
    end,
})
autocmd("FileType", {
    pattern = { "veil" },
    callback = function(_)
        vim.opt_local.list = false
    end,
})

-- Remove whitespace on save
--[[autocmd("BufWritePre", {
	pattern = "*",
	command = ":%s/\\s\\+$//e",
})]]

-- Don't auto commenting new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})
--[[ autocmd("BufEnter", {
  pattern = "*",
  command = "vertical resize 80"
}) ]]

-- Settings for filetypes:
-- Disable line length marker
augroup("setLineLength", { clear = true })
autocmd("Filetype", {
    group = "setLineLength",
    pattern = { "text", "markdown", "html", "xhtml", "javascript", "typescript" },
    command = "setlocal cc=0",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
    group = "setIndent",
    pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
    command = "setlocal shiftwidth=2 tabstop=2",
})

-- Terminal settings:
-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
    command = "command! Term :botright vsplit term://$SHELL",
})

--[[ Enter insert mode when switching to terminal
autocmd("TermOpen", {
	command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

-- skip terms from NeoTest
autocmd("TermOpen", {
	pattern = "*",
	command = "if nvim_buf_get_name(0) =~# '^term://.*' | startinsert | endif",
})]]

-- Close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "term://*",
    command = "stopinsert",
})

user_command("SessionSave", function(opts)
    local sessions_dir = vim.fn.stdpath("data") .. "/sessions/"
    local sname = opts.args .. ".vim"
    local path = sessions_dir .. sname
    print(path)
    vim.notify("Session " .. sname .. " saved")
    vim.cmd("mks! " .. path)
end, { bang = false, desc = "Create named session ", nargs = 1 })

user_command("SessionLoad", function(opts)
    local sessions_dir = vim.fn.stdpath("data") .. "/sessions/"
    local sname = opts.args .. ".vim"
    local path = sessions_dir .. sname
    print(path)
    vim.notify("Session " .. sname .. " loaded")
    vim.cmd("source " .. path)
end, { bang = false, desc = "Load named session ", nargs = 1 })

autocmd("BufNewFile", {
    pattern = { "/dev/shm/gopass*" },
    command = 'setlocal noswapfile nobackup noundofile shada=""',
})
autocmd("BufRead", {
    pattern = { "/dev/shm/gopass*" },
    command = 'setlocal noswapfile nobackup noundofile shada=""',
})
