return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        config = function()
          require("nvim-navbuddy").setup { lsp = { auto_attach = true } }
          vim.keymap.set("n", "<leader>ln", function()
            require("nvim-navbuddy").open()
          end, { desc = "LSP: [G]oto [N]avbuddy" })
        end,
        dependencies = { "MunifTanjim/nui.nvim" },
      },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "haringsrob/nvim_context_vt",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("custom.lsp").setup()
    end,
  },
  { "mfussenegger/nvim-jdtls" }, -- the exension for built in LSP jdtls
  {
    "SmiteshP/nvim-navic",
  },
  {
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  {
    "utilyre/barbecue.nvim",
    enabled = false,
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {},
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
}
