vim.g.cord_defer_startup = true -- defer to manual setup()
vim.pack.add { { src = "https://github.com/vyfor/cord.nvim", confirm = false } }

local uid = assert(io.popen "id -u"):read "*l"
local ipc = "/run/user/" .. uid .. "/discord-ipc-0"

if vim.fn.filereadable(ipc) == 1 then
  require("cord").setup {
    log_level = vim.log.levels.WARN,
    enabled = true,
    display = {
      theme = "catppuccin",
      flavor = "accent",
    },
    extensions = {
      visibility = {
        cache = false,
        precedence = "whitelist",
        rules = {
          whitelist = {
            "~/.config/nvim/", -- matches path
          },
        },
      },
    },
  }
end
