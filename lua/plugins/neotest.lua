vim.g["test#neovim#term_position"] = "vert"
vim.g["test#strategy"] = "vimux"
vim.g.VimuxOrientation = "v"
vim.g.VimuxHeight = "30"

-- local function get_neotest_python_path()
--     return "./neotest.py"
-- end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "nvim-treesitter/nvim-treesitter",
      "preservim/vimux",
      "rouge8/neotest-rust",
      "vim-test/vim-test",
      "nvim-neotest/nvim-nio",
    },
    lazy = false,
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-rust",
          require "neotest-python",
          require "neotest-plenary",
          require "neotest-vim-test" { ignore_filetypes = {} },
        },
        summary = {
          enabled = true,
        },
        diagnostic = {
          enabled = true,
          severity = 1,
        },
        status = {
          enabled = true,
          virtual_text = true,
          signs = false,
        },
      }
    end,
  },
}
