local pack = require "plugins.pack"

vim.cmd.packadd "cfilter"
vim.cmd.packadd "nvim.undotree"
vim.cmd.packadd "nvim.difftool"

pack.add {
  { src = "https://github.com/chaoren/vim-wordmotion" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/stevearc/quicker.nvim" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    update_hook = function()
      vim.notify "[nvim-treesitter] TSUpdate"
      vim.cmd "TSUpdate"
    end,
  },
  {
    src = "https://github.com/ravsii/tree-sitter-d2",
    install_hook = function(ev)
      vim.notify "[tree-sitter-d2] make nvim-install"
      vim.system({ "make", "nvim-install" }, { cwd = ev.data.path }):wait()
    end,
    update_hook = function(ev)
      vim.notify "[tree-sitter-d2] make nvim-install"
      vim.system({ "make", "nvim-install" }, { cwd = ev.data.path }):wait()
    end,
  },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/OXY2DEV/markview.nvim" },
}

require("mini.pairs").setup()

require("quicker").setup {
  keys = {
    {
      ">",
      function()
        require("quicker").expand { before = 2, after = 2, add_to_existing = true }
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
}

require("conform").setup {
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    javascript = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    python = { "black" },
    r = { "air" },
  },
}

vim.keymap.set("n", "glf", function()
  require("conform").format()
end, { silent = true, desc = "Format buffer" })

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ensure_installed = {
      "lua",
      "bash",
      "markdown",
      "markdown_inline",
      "yaml",
      "toml",
    }
    local already_installed = require("nvim-treesitter.config").get_installed()
    local parsers_to_install = vim
      .iter(ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end)
      :totable()

    if #parsers_to_install > 0 then
      require("nvim-treesitter").install(parsers_to_install)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("todo-comments").setup {
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  highlight = {
    multiline = true,
    multiline_pattern = "^.",
    multiline_context = 10,
    before = "",
    keyword = "wide",
    after = "fg",
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
    max_line_len = 400,
    exclude = {},
  },
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
}
-- mappings to navigate/find tags
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>ftT", function()
  require("snacks").picker.todo_comments()
end, { desc = "Find todo comments" })

vim.keymap.set("n", "<leader>fte", function()
  require("snacks").picker.todo_comments { keywords = { "FIX", "FIXME", "BUX", "FIXIT", "ISSUE" } }
end, { desc = "Fix todo comments - FIX, FIXME, BUG, ISSUE" })

vim.keymap.set("n", "<leader>fti", function()
  require("snacks").picker.todo_comments { keywords = { "INFO", "NOTE" } }
end, { desc = "Fix todo comments - INFO, NOTE" })

vim.keymap.set("n", "<leader>ftw", function()
  require("snacks").picker.todo_comments { keywords = { "WARN", "HACK", "WARNING", "XXX" } }
end, { desc = "Fix todo comments - WARN, HACK" })

vim.keymap.set("n", "<leader>ftt", function()
  require("snacks").picker.todo_comments { keywords = { "TODO" } }
end, { desc = "Fix todo comments - TODO" })

vim.keymap.set("n", "<leader>ftp", function()
  require("snacks").picker.todo_comments { keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTOMIZE" } }
end, { desc = "Fix todo comments - PERF, OPTIM, PERFORMANCE, OPTOMIZE" })
