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

M.comment = function()
  local present, nvim_comment = pcall(require, "Comment")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "numToStr/Comment.nvim")
  nvim_comment.setup(options)
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
      mode = "background", -- Set the display mode.
    },
  }

  options = load_override(options, "NvChad/nvim-colorizer.lua")
  colorizer.setup(options["filetypes"], options["user_default_options"])

  vim.cmd("ColorizerAttachToBuffer")
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

M.luasnip = function()
  local present, luasnip = pcall(require, "luasnip")

  if not present then
    return
  end

  local options = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  }

  options = load_override(options, "L3MON4D3/LuaSnip")
  luasnip.config.set_config(options)
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.luasnippets_path or "" })

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
          and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

M.notify = function()
  local present, notify = pcall(require, "notify")

  if not present then
    return
  end

  local options = {
    level = "info",
    background_color = "#000000",
  }

  options = load_override(options, "rcarriga/nvim-notify")
  notify.setup(options)
  -- vim.notify = notify
end

M.fidget = function()
  local present, fidget = pcall(require, "fidget")

  if not present then
    return
  end

  local options = {}
  fidget.setup(options)
end

M.todo_comments = function()
  -- TODO: works?
  local present, todo_comments = pcall(require, "todo-comments")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "folke/todo-comments.nvim")
  todo_comments.setup(options)
end

M.auto_session = function()
  local present, session = pcall(require, "auto-session")

  if not present then
    return
  end

  local options = {
    log_level = "info",
    auto_session_suppress_dirs = { "~/", "/tmp" },
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

M.zk = function()
  local present, zk = pcall(require, "zk")

  if not present then
    return
  end

  local options = {
    -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
    -- it's recommended to use "telescope" or "fzf"
    picker = "telescope",

    lsp = {
      -- `config` is passed to `vim.lsp.start_client(config)`
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
        -- on_attach = ...
        -- etc, see `:h vim.lsp.start_client()`
      },

      -- automatically attach buffers in a zk notebook that match the given filetypes
      auto_attach = {
        enabled = true,
        filetypes = { "markdown" },
      },
    },
  }
  options = load_override(options, "mickael-menu/zk-nvim")
  zk.setup(options)
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

M.lspsaga = function()
  local present, lspsaga = pcall(require, "lspsaga")

  if not present then
    return
  end

  local options = {
    symbol_in_winbar = {
      in_custom = false,
      enable = true,
      click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
        local st = node.range.start
        local en = node.range["end"]
        if button == "l" then
          if clicks == 2 then
            -- double left click to do nothing
          else -- jump to node's starting line+char
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == "r" then
          if modifiers == "s" then
            print("lspsaga") -- shift right click to print "lspsaga"
          end -- jump to node's ending line+char
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then
          -- middle click to visual select node
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd("normal v")
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end,
    },
  }
  options = load_override(options, "glepnir/lspsaga.vim")
  lspsaga.init_lsp_saga(options)
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

M.mason = function()
  local present, mason = pcall(require, "mason")

  if not present then
    return
  end

  local options = {}
  options = load_override(options, "williamboman/mason.nvim")
  mason.setup(options)
end

M.mason_lspconfig = function()
  local present, mason_lspconfig = pcall(require, "mason-lspconfig")

  if not present then
    return
  end

  local options = {
    ensure_installed = { "sumneko_lua", "efm", "pyright"}
  }
  options = load_override(options, "williamboman/mason-lspconfig.nvim")
  mason_lspconfig.setup(options)
  mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
  }
end


return M
