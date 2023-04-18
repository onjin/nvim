-- luacheck: globals vim
local M = {}

local utils = require("core.utils")
local load_override = require("core.utils").load_override

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, cmp = pcall(require, "cmp")

  if not (present1 and present2) then
    return
  end

  local options = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  }

  options = load_override(options, "windwp/nvim-autopairs")
  autopairs.setup(options)

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.gitsigns = function()
  local present, gitsigns = pcall(require, "gitsigns")

  if not present then
    return
  end

  -- require("base46").load_highlight "git"

  local options = {
    signs = {
      add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
      change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
      delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
      topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
      changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      local git_mappings = utils.load_config().mappings.gitsigns
      utils.load_mappings({ git_mappings }, { buffer = bufnr })
      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })
    end,
  }

  options = load_override(options, "lewis6991/gitsigns.nvim")
  gitsigns.setup(options)
end

M.blankline = function()
  local present, blankline = pcall(require, "indent_blankline")

  if not present then
    return
  end

  -- require("base46").load_highlight "blankline"

  local options = {
    indentLine_enabled = 1,
    filetype_exclude = {
      "help",
      "terminal",
      "alpha",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "lsp-installer",
      "",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = true,
  }

  options = load_override(options, "lukas-reineke/indent-blankline.nvim")
  blankline.setup(options)
end

M.colorizer = function()
  local present, colorizer = pcall(require, "colorizer")

  if not present then
    return
  end

  local options = {
    filetypes = {
      "*",
    },
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue
      RRGGBBAA = false, -- #RRGGBBAA hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode. background, foreground, virtualtext
    },
  }

  options = load_override(options, "NvChad/nvim-colorizer.lua")
  colorizer.setup(options)

  -- vim.cmd("ColorizerAttachToBuffer")
end

M.devicons = function()
  local present, devicons = pcall(require, "nvim-web-devicons")

  if present then
    -- require("base46").load_highlight "devicons"

    -- local options = { override = require("nvchad_ui.icons").devicons }
    local options = {}
    options = require("core.utils").load_override(options, "kyazdani42/nvim-web-devicons")

    devicons.setup(options)
  end
end



M.auto_session = function()
  local present, session = pcall(require, "auto-session")

  if not present then
    return
  end
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  local options = {
    log_level = "info",
    auto_session_suppress_dirs = { "~/", "/tmp" },
    auto_restore_enabled = false,
  }
  options = load_override(options, "rmagatti/auto-session")
  session.setup(options)
end
M.session_lens = function()
  local present, session = pcall(require, "session-lens")

  if not present then
    return
  end

  local options = {
    path_display = { "shorten" },
    theme_conf = { border = true },
    previewer = false,
  }
  options = load_override(options, "rmagatti/session-lens")
  session.setup(options)
end

M.lsp_signature = function()
  local present, lsp_signature = pcall(require, "lsp_signature")

  if not present then
    return
  end

  local options = {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "rounded",
    },
    hint_prefix = "💡",
  }
  options = load_override(options, "ray-x/lsp_signature.nvim")
  lsp_signature.setup(options)
end

M.neogen = function()
  local present, neogen = pcall(require, "neogen")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "danymat/neogen")
  neogen.setup(options)
end

M.tmux = function()
  local present, tmux = pcall(require, "tmux")

  if not present then
    return
  end

  local options = {
    -- overwrite default configuration
    -- here, e.g. to enable default bindings
    copy_sync = {
      -- enables copy sync and overwrites all register actions to
      -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
      enable = true,
    },
    navigation = {
      -- enables default keybindings (C-hjkl) for normal mode
      enable_default_keybindings = true,
    },
    resize = {
      -- enables default keybindings (A-hjkl) for normal mode
      enable_default_keybindings = true,
    },
  }
  options = load_override(options, "aserowy/tmux.nvim")
  tmux.setup(options)
end

M.cosmic_ui = function()
  local present, cosmic_ui = pcall(require, "cosmic-ui")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "CosmicNvim/cosmic-ui")
  cosmic_ui.setup(options)
end

M.project = function()
  local present, project = pcall(require, "project_nvim")

  if not present then
    return
  end

  local options = {
    silent_chdir = false,
  }
  options = load_override(options, "ahmedkhalf/project.nvim")
  project.setup(options)
end

M.toggleterm = function()
  local present, toggleterm = pcall(require, "toggleterm")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "akinsho/toggleterm.nvim")
  toggleterm.setup(options)
end


M.crates = function()
  local present, crates = pcall(require, "crates")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "saecki/crates.nvim")
  crates.setup(options)
end

M.regexplainer = function()
  local present, regexplainer = pcall(require, "regexplainer")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "bennypowers/nvim-regexplainer")
  regexplainer.setup(options)
end

M.zen = function()
  local present, zen = pcall(require, "true-zen")

  if not present then
    return
  end

  local options = {
    integrations = {
      tmux = true, -- hide tmux status bar in (minimalist, ataraxis)
      kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
        enabled = true,
        font = "+3",
      },
      twilight = false, -- enable twilight (ataraxis)
      lualine = true, -- hide nvim-lualine (ataraxis)
    },
  }
  options = load_override(options, "Pocco81/true-zen.nvim")
  zen.setup(options)
end

return M
