if vim.g.minimal ~= nil then
	require("onjin.minimal")
	return
end

_G.dbg = vim.print

require("onjin.commands")
require("onjin.options")
require("onjin.lazy")
