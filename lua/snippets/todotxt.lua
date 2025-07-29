require("luasnip.session.snippet_collection").clear_snippets "todotxt"

local ls = require "luasnip"

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt
local today = os.date("%Y-%m-%d")

ls.add_snippets("todotxt", {
  s("#add-full", fmt("({}) " .. today .. " {} +{} @{}", { c(1, { t("A"), t("B"), t("C"), t("D") }), i(2), i(3), i(4) })),
  s("#add-simple", fmt("({}) " .. today .. " {}", { c(1, { t("A"), t("B"), t("C"), t("D") }), i(2) })),
  s("#done", fmt("x ({}) " .. today .. " " .. today .. " {} ", { c(1, { t("A"), t("B"), t("C"), t("D") }), i(2) })),
  s("#date", fmt(today, {})),
})
