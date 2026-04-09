local pack = require "plugins.pack"

vim.g.cord_defer_startup = true

pack.add {
  {
    src = "https://github.com/vyfor/cord.nvim",
    update_hook = function(ev)
      if not ev.data.active then
        vim.cmd.packadd "cord.nvim"
      end
      vim.cmd "Cord update"
    end,
  },
}

local runtime_dir = vim.env.XDG_RUNTIME_DIR
if not runtime_dir and vim.uv.os_get_passwd then
  local passwd = vim.uv.os_get_passwd()
  if passwd and passwd.uid then
    runtime_dir = "/run/user/" .. passwd.uid
  end
end

if not runtime_dir then
  return
end

local ipc = runtime_dir .. "/discord-ipc-0"

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
            "~/.config/nvim/",
          },
        },
      },
    },
  }
end
