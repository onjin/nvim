-- luacheck: globals vim
local plugins = {
  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open("indent-blankline.nvim")
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },
  ["tpope/vim-fugitive"] = {},

  -- file managing , picker etc
  ["kyazdani42/nvim-tree.lua"] = {
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("plugins.configs.nvimtree")
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    tag = "v2.*",
    config = function()
      require("plugins.configs.others").toggleterm()
    end,
  },
  -- sessions
  ["ahmedkhalf/project.nvim"] = {
    config = function()
      require("plugins.configs.others").project()
    end,
  },
  -- misc plugins

  ["folke/todo-comments.nvim"] = {
    config = function()
      require("plugins.configs.others").todo_comments()
    end,
  },
  ["danymat/neogen"] = {
    config = function()
      require("plugins.configs.others").neogen()
    end,
  },

  ["t9md/vim-quickhl"] = {},
  -- testing
  ["NTBBloodbath/rest.nvim"] = {
    config = function()
      require("plugins.configs.rest_nvim")
    end,
    requires = { "nvim-lua/plenary.nvim" },
  },
  ["iamcco/markdown-preview.nvim"] = {
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- rust crates.io
  ["saecki/crates.nvim"] = {
    tag = "v0.3.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.configs.others").crates()
    end,
  },
  -- requirements.txt syntax
  ["junegunn/limelight.vim"] = {},
  ["folke/twilight.nvim"] = {},
  -- Debugging
  ["mfussenegger/nvim-dap"] = {},
  ["mfussenegger/nvim-dap-python"] = {
    config = function()
      require("plugins.configs.dap").dappython()
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    config = function()
      require("plugins.configs.dap").dapui()
    end,
  },
  ["weirongxu/plantuml-previewer.vim"] = {
    requires = {
      "tyru/open-browser.vim",
      "aklt/plantuml-syntax",
    },
  },

  -- Only load whichkey after all the gui
  ["Pocco81/true-zen.nvim"] = {
    config = function()
      require("plugins.configs.others").zen()
    end
  },

  ["~/.config/nvim/local/quickstart"] = {
    config = function()
      require('quickstart').setup({})
    end
  },
}
-- vim:foldmarker={,}
