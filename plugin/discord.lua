vim.pack.add { "https://github.com/vyfor/cord.nvim" }

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

require("cord").setup {
  log_level = vim.log.levels.WARN,
  enabled = true,
  display = {
    theme = "catppuccin",
    flavor = "accent",
  },
  extensions = {
 "diagnostics",
    visibility = {
      rules = {
        blacklist = {
          '~/Workspace/p', -- matches path
        },
      },
    },
  },
}
