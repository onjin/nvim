local function setup_telescope()
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"
  local config = require("telescope.config").values
  local sorters = require "telescope.sorters"

  local live_multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job {
      command_generator = function(prompt)
        if not prompt or prompt == "" then
          return nil
        end

        local pieces = vim.split(prompt, "  ") -- Two spaces
        local args = { "rg" } -- RipGrep
        if pieces[1] then
          table.insert(args, "-e") -- "rg --help" -> "-e defines pattern to search for"
          table.insert(args, pieces[1])
        end

        if pieces[2] then
          table.insert(args, "-g") -- "-glob", i.e. filetype
          table.insert(args, pieces[2])
        end

        return vim
          .iter({
            args,
            -- extra ripgrep flags to make it play nice with telescope
            { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
          })
          :flatten()
          :totable()
      end,
      entry_maker = make_entry.gen_from_vimgrep(opts),
      cwd = opts.cwd,
    }

    pickers
      .new(opts, {
        debounce = 100,
        prompt_title = "Live MultiGrep",
        finder = finder,
        previewer = config.grep_previewer(opts),
        sorter = sorters.empty(),
      })
      :find()
  end

  --- Live MultiGrep (with filetypes!)
  -- Allows you to grep for a string (smart-case) while restricting for filetypes or paths by separating your grep from the glob with two spaces "  "
  --
  -- For instance:
  -- `opts  **/plugins/**` will search for all instances of `opts` under the `plugins`-directory.
  -- `fetchuser  *.tsx` will search for all instances of `fetchuser` in `.tsx` files.
  -- `writer  **/client/**/*.go` will search for all instances of `writer` in `.go` files under the `client`-directory
  M.multi_grep = function()
    live_multigrep()
  end

  require("telescope").setup {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      initial_mode = "insert",
    },
    extensions = {
      wrap_results = true,

      fzf = {},
      -- history = {
      --   path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      --   limit = 100,
      -- },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {},
      },
    },
  }

  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "smart_history")
  pcall(require("telescope").load_extension, "ui-select")
  pcall(require("telescope").load_extension, "notify")

  -- See `:help telescope.builtin`
  local builtin = require "telescope.builtin"

  vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
  -- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sg", live_multigrep, { desc = "[S]earch Multi [G]rep" })
  vim.keymap.set("n", "<leader>sG", builtin.git_files, { desc = "[S]earch by [G]it Files" })
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>sl", builtin.loclist, { desc = "[S]earch [L]oclist" })
  vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })
  vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "[S]earch [Q]uickfix" })
  vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "[/] Fuzzily search in current buffer" })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    }
  end, { desc = "[S]earch [/] in Open Files" })

  -- Shortcut for editing searching your Neovim configuration files

  vim.keymap.set("n", "<space>en", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "[E]earch [N]eovim files" })
  vim.keymap.set("n", "<space>ep", function()
    builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
  end, { desc = "[E]earch Neovim Installed [P]ackages" })
end
return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

      "nvim-telescope/telescope-ui-select.nvim",
      -- "nvim-telescope/telescope-smart-history.nvim",
      -- "kkharji/sqlite.lua",
    },
    config = setup_telescope,
  },
}
