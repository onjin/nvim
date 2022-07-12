require "config.options"
require "config.keymaps"
require "config.plugins"

-- 
local status_ok, comment = pcall(require, "packer")
if not status_ok then
  return
end

require "config.theme"
require "config.general"

require "config.black"
require "config.dap"
require "config.dashboard-nvim"
require "config.lsp"
require "config.lualine"
require "config.neogen"
require "config.testing"
require "config.nvim-treesitter"
require "config.nvim-tree"
require "config.telescope"

require "config.autocmds"

require "utils" .load_dynamic_configs()
