vim.g.cord_defer_startup = true -- defer to manual setup()
vim.pack.add { { src = "https://github.com/vyfor/cord.nvim", confirm = false } }

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "cord.nvim" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "cord.nvim"
      end
      vim.cmd "Cord update"
    end
  end,
})
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
