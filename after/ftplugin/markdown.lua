local set = vim.opt_local

set.conceallevel = 2
set.foldlevel = 99

local function sanitize_shell_string(input)
  local sanitized = input:gsub("'", "'\\''")
  return "'" .. sanitized .. "'"
end

local function preview_markdown()
  if vim.g.glow_buf and vim.api.nvim_buf_is_valid(vim.g.glow_buf) and vim.api.nvim_win_is_valid(vim.g.glow_win) then
    vim.api.nvim_set_current_win(vim.g.glow_win)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    vim.g.glow_buf = buf

    local current_buf = vim.api.nvim_get_current_buf()

    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
    local markdown = table.concat(lines, "\n")
    local sanitized = sanitize_shell_string(markdown)

    vim.cmd("rightbelow vert sbuffer " .. buf)

    local glow_win = vim.api.nvim_get_current_win()
    vim.g.glow_win = glow_win
    vim.api.nvim_win_set_option(glow_win, "number", false)
    vim.api.nvim_win_set_option(glow_win, "cursorline", false)
    vim.api.nvim_win_set_option(glow_win, "relativenumber", false)

    vim.fn.termopen("glow <( echo " .. sanitized .. ")\n")
  end
end

vim.keymap.set("n", "<leader>m", preview_markdown, {})

-- Expose markdown function as Vim command
vim.api.nvim_create_user_command("Glow", preview_markdown, {})

-- Set up keymap
vim.keymap.set("n", "<leader>m", "<cmd>Glow<cr>", {})
