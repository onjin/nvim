require("luasnip.session.snippet_collection").clear_snippets "java"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("java", {
  s("andDo#print", fmt("andDo(MockMvcResultHandlers.print())", {})),
})
