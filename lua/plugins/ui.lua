local M = {}
local pack = require "plugins.pack"
local has_ui = #vim.api.nvim_list_uis() > 0
local transparent_background = true

if has_ui then
  -- require("vim._core.ui2").enable {}
end

pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.tabline", name = "mini.tabline" },
  { src = "https://github.com/nvim-mini/mini.statusline", name = "mini.statusline" },
  { src = "https://github.com/nvim-mini/mini-git", name = "mini.git" },
  { src = "https://github.com/nvim-mini/mini.diff", name = "mini.diff" },
  { src = "https://github.com/nvim-mini/mini.indentscope" },
  { src = "https://github.com/nvim-mini/mini.notify" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  { src = "https://github.com/lewis6991/hover.nvim" },
  { src = "https://github.com/eatgrass/maven.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" }, -- for maven.nvim
}

local function apply_catppuccin()
  require("catppuccin").setup {
    flavour = "auto",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = transparent_background,
  }
  vim.cmd.colorscheme "catppuccin-nvim"
end

function M.transparent_background()
  return transparent_background
end

function M.set_transparent_background(state)
  transparent_background = state
  apply_catppuccin()
  M.apply_highlights()
end

function M.apply_highlights()
  vim.api.nvim_set_hl(0, "MiniStatuslineDiagnosticError", {
    fg = "#f38ba8",
    bold = true,
  })

  local palette = require("catppuccin.palettes").get_palette()
  vim.api.nvim_set_hl(0, "HoverActiveSource", {
    fg = palette.base,
    bg = palette.mauve,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "HoverInactiveSource", {
    fg = palette.overlay0,
    bg = palette.surface0,
  })
  vim.api.nvim_set_hl(0, "HoverSourceLine", {
    fg = palette.overlay0,
    bg = palette.mantle,
  })
end

apply_catppuccin()

if has_ui then
  require("mini.notify").setup()
  require("mini.icons").setup()
  require("mini.icons").tweak_lsp_kind()
  require("mini.icons").mock_nvim_web_devicons()

  require("mini.tabline").setup()
  require("mini.statusline").setup {
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
        local git = MiniStatusline.section_git { trunc_width = 40 }
        local diff = MiniStatusline.section_diff { trunc_width = 75 }
        local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
        local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
        local filename = MiniStatusline.section_filename { trunc_width = 140 }
        local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
        local location = MiniStatusline.section_location { trunc_width = 75 }
        local search = MiniStatusline.section_searchcount { trunc_width = 75 }

        return MiniStatusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
          { hl = "MiniStatuslineDiagnosticError", strings = { diagnostics } },
          { hl = "MiniStatuslineDevinfo", strings = { lsp } },
          "%<",
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=",
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        }
      end,
    },
  }
  require("mini.indentscope").setup()

  require("hover").config {
    --- List of modules names to load as providers.
    providers = {
      "hover.providers.diagnostic",
      "hover.providers.lsp",
      "hover.providers.dap",
      "hover.providers.man",
      "hover.providers.dictionary",
      "hover.providers.java_constructors",
      -- Optional, disabled by default:
      -- 'hover.providers.gh',
      -- 'hover.providers.gh_user',
      -- 'hover.providers.jira',
      -- 'hover.providers.fold_preview',
      -- 'hover.providers.highlight',
    },
    mouse_providers = {
      -- "hover.providers.lsp",
    },
  }
  M.apply_highlights()
  -- Setup keymaps
  vim.keymap.set("n", "K", function()
    require("hover").open()
  end, { desc = "hover.nvim (open)" })
end

require("mini.git").setup()
require("mini.diff").setup()

require("nvim-highlight-colors").setup {
  render = "virtual",
  virtual_symbol = "⚫︎",
  virtual_symbol_suffix = "",
}

if has_ui then
  vim.cmd [[
    aunmenu PopUp
    autocmd! nvim.popupmenu
  ]]
end

-- inline diagnostic
pack.add {
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
}
require("tiny-inline-diagnostic").setup {
  options = {
    multilines = { enabled = true },
    show_source = { enabled = true },
    override_open_float = true,
  },
}
vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics

vim.keymap.set("n", "<leader>de", "<cmd>TinyInlineDiag enable<cr>", { desc = "Enable diagnostics" })
vim.keymap.set("n", "<leader>dd", "<cmd>TinyInlineDiag disable<cr>", { desc = "Disable diagnostics" })
vim.keymap.set("n", "<leader>dt", "<cmd>TinyInlineDiag toggle<cr>", { desc = "Toggle diagnostics" })
vim.keymap.set(
  "n",
  "<leader>dc",
  "<cmd>TinyInlineDiag toggle_cursor_only<cr>",
  { desc = "Toggle cursor-only diagnostics" }
)
vim.keymap.set("n", "<leader>dr", "<cmd>TinyInlineDiag reset<cr>", { desc = "Reset diagnostic options" })

-- folding rules
pack.add {
  { src = "https://github.com/kevinhwang91/nvim-ufo" },
  { src = "https://github.com/kevinhwang91/promise-async" },
}

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup {
  enable_get_fold_virt_text = true,
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
  open_fold_hl_timeout = 150,
  close_fold_kinds_for_ft = {
    default = { "imports", "comment" },
    json = { "array" },
    c = { "comment", "region" },
    python = { "import_statement", "import_from_statement", "comment" },
    java = { "import_declaration", "block_comment" },
  },
  close_fold_current_line_for_ft = {
    default = true,
    c = false,
  },
}
vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "zk", function()
  require("ufo").peekFoldedLinesUnderCursor()
end)

-- maven
require("maven").setup {
  executable = "mvn",
  settings = nil,
  commands = {
    { cmd = { "verify", "--quiet" }, desc = "verify quietly" },
  },
}
vim.keymap.set("n", "<leader>mm", "<cmd>Maven<cr>", { desc = "Maven Projects" })

return M
