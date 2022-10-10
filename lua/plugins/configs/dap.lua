-- luacheck: globals vim
local M = {}

local load_override = require("core.utils").load_override

M.dappython = function()
  local present, dappython = pcall(require, "dap-python")

  if not present then
    return
  end

  local options = '~/.pyenv/versions/debugpy/bin/python'
  dappython.setup(options)
  vim.notify('dap python set')
end

M.dapui = function()
  local present, dapui = pcall(require, "dapui")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "rcarriga/nvim-dap-ui")
  dapui.setup(options)
end

return M
