require("luasnip.session.snippet_collection").clear_snippets "lua"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

-- https://github.com/folke/dot/blob/master/nvim/snippets/lua.json
ls.add_snippets("lua", {
  s(
    "autocmd",
    fmt(
      [[
      vim.api.nvim_create_autocmd("{event}", {{
        group = vim.api.nvim_create_augroup("{group}", {{ clear = true }}),
        callback = function(ev)
          {body}
       end
      }})

  ]],
      { event = i(1, "event"), group = i(2, "group"), body = i(3, "") }
    )
  ),
  s(
    "autogroup",
    fmt([[vim.api.nvim_create_augroup("{group}", {{ clear = true }}){nl}]], { group = i(1, "group"), nl = i(2, "") })
  ),
  s("win", fmt([[local win = vim.api.nvim_get_current_win()]], {})),
  s("buf", fmt([[local buf = vim.api.nvim_get_current_buf()]], {})),
  s("bufvalid", fmt([[vim.api.nvim_buf_is_valid({buf})]], { buf = i(1, "buf") })),
  s("winvalid", fmt([[vim.api.nvim_win_is_valid({win})]], { win = i(1, "win") })),
})
