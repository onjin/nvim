-- luacheck: globals vim

if vim.g.minimal ~= nil then
  require "minimal"
  return
end

_G.dbg = vim.print

require "commands"
require "options"
require "load_plugins"
