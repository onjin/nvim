local set = vim.opt_local

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
  end,
})

-- :qs - write all, session and quit
--
-- Create a function for the command
local function quit_session_command()
  vim.cmd "wa"   -- Save all files
  vim.cmd "mks!" -- Create or overwrite a session
  vim.cmd "qa"   -- Quit all
end

-- Create a custom command
vim.api.nvim_create_user_command("QuitSession", quit_session_command, {})

-- testing
vim.api.nvim_create_user_command("ListChars", function()
  local options = {
    { name = "Default", value = { tab = "» ", trail = "·", nbsp = "␣" } },
    {
      name = "Symbols",
      value = {
        space = " ",
        tab = "␋ ",
        eol = "␤",
        trail = "␠",
        precedes = "«",
        extends = "»",
      },
    },
    {
      name = "Fancy",
      value = {
        space = " ",
        tab = "▸ ",
        eol = "¬",
        trail = "●",
        precedes = "«",
        extends = "»",
      },
    },
    {
      name = "Plain",
      value = {
        space = " ",
        tab = ">-",
        eol = "$",
        trail = "~",
        precedes = "<",
        extends = ">",
      },
    },
  }

  -- Extract the display names for the UI
  local names = vim.tbl_map(function(option)
    return option.name
  end, options)

  vim.ui.select(names, { prompt = "Select Listchars Style:" }, function(choice)
    if choice then
      -- Find the corresponding value for the selected name
      for _, option in ipairs(options) do
        if option.name == choice then
          vim.opt.listchars = option.value
          print("Listchars set to: " .. option.name)
          return
        end
      end
    else
      print "No selection made."
    end
  end)
end, {})


-- todo.txt | done.txt support
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  callback = function(args)
    local name = vim.fn.fnamemodify(args.file, ":t"):lower()
    if name == "todo.txt" or name == "done.txt" then
      vim.bo.filetype = "todotxt"
    end
  end,
})
