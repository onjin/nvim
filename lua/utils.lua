local M = {}

function M.map(mode, lhs, rhs, opts)
	-- example: map("n", "<Leader>c", "cclose<CR>", { silent = true})
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.colors(scheme)
	-- example: colors('PaperColor')
	vim.cmd(string.format('colorscheme %s', scheme))
	M.save_user_conf('colors', string.format("vim.cmd('colorscheme %s')", scheme))
	require('notify').notify(string.format('Color scheme changed to %s', scheme))
end

function M.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then io.close(f) return true else return false end
end

function M.load_user_config(name)
	local path = os.getenv('HOME') .. "/.config/nvim/lua/local/" .. name .. ".lua"

	if M.file_exists(path) then
		local status_ok, _ = pcall(require, 'local.' .. name)

		if not status_ok then
			vim.notify(string.format('Failed loading %s with status %s', path, status_ok), vim.log.levels.ERROR)
		end

	end
end

function M.save_user_conf(name, data)
	local path = os.getenv('HOME') .. "/.config/nvim/lua/local/" .. name .. ".lua"
	local file = io.open(path, 'w')
	file:write(data)
	file:close()
end

function M.load_dynamic_config()
	M.load_user_config("colors")
end

function M.reload_nvim_conf()
  for name,_ in pairs(package.loaded) do
    if name:match('^core') or name:match('^config') or name:match('^plugins') then
      package.loaded[name] = nil
    end
  end

  require('init')
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

return M
