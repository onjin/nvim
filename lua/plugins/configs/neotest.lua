local present, neotest = pcall(require, "neotest")

if not present then
	return
end
-- vim-test
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#strategy"] = "vimux"
vim.g.VimuxOrientation = "h"
vim.g.VimuxHeight = "50"

-- neotest
local options = {
	adapters = {
		--[[
    require("neotest-python")({
      dap = { justMyCode = false },
      args = {"--log-level", "DEBUG"},
      -- Runner to use. Will use pytest if available by default.
      -- Can be a function to return dynamic value.
      runner = "pytest",
      executable = "docker-compose exec app pytest --ini=config.ini"
    }),
    --]]
		require("neotest-vim-test")({ ignore_filetypes = {} }),
		require("neotest-plenary"),
	},
}
options = require("core.utils").load_override(options, "nvim-neotest/neotest")
neotest.setup(options)
