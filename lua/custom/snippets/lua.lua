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
})
