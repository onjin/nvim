if vim.g.minimal ~= nil then
	require("onjin.minimal")
	return
end

_G.dbg = vim.print

-- require("onjin.util")
require("onjin.commands")
require("onjin.options")
require("onjin.lazy")
-- require("onjin.lsp")
-- require("onjin.actions")
