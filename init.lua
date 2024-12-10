--[[ 
-- Support of setting global variables per project by  .nvimrc.ini file
-- 
-- Example .nvimrc.ini:
-- 
-- ai_enabled = 1
-- some_other = 'text'
--
-- Then you can use them by
-- if vim.g.ai_enabled then ... end
--
--]]

-- vim global settings here, so we can override it with .nvimrc.ini
vim.g.mapleader = ","
vim.g.ai_enabled = 0
vim.g.autoformat_on_save_enabled = 0
vim.g.lsp_servers_ensure_installed = { "lua_ls" }
vim.g.lsp_disable_semantic_tokens = {
  lua = true,
} -- disable semanticTokensProvider for filetype
vim.g.treesitter_ensure_installed = {
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
}

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function load_ini_file(file)
  local variables = {}
  for line in io.lines(file) do
    local key, value = line:match "^(.-)%s*=%s*(.-)%s*$"
    if key and value then
      key = trim(key)
      value = trim(value)
      if value:match "^'.*'$" or value:match '^".*"$' then
        value = value:sub(2, -2) -- Remove quotes
      elseif tonumber(value) then
        value = tonumber(value)
      end
      variables[key] = value
    end
  end
  return variables
end

local function set_global_variables(variables)
  for key, value in pairs(variables) do
    vim.g[key] = value
  end
end

-- Load and set variables from .nvimrc.ini
local ini_file = vim.fn.getcwd() .. "/.nvimrc.ini"
if vim.fn.filereadable(ini_file) == 1 then
  local variables = load_ini_file(ini_file)
  set_global_variables(variables)
end

--[[ 
-- Setup initial configuration,
-- 
-- Primarily just download and execute lazy.nvim
--]]

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
  change_detection = {
    notify = false,
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
