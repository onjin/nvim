require("luasnip.session.snippet_collection").clear_snippets "markdown"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  s("!NOTE", fmt("> [!NOTE] {}\n> {}", { i(1), i(0) })),
  s("!TIP", fmt("> [!TIP] {}\n> {}", { i(1), i(0) })),
  s("!IMPORTANT", fmt("> [!IMPORTANT] {}\n> {}", { i(1), i(0) })),
  s("!WARNING", fmt("> [!WARNING] {}\n> {}", { i(1), i(0) })),
  s("!CAUTION", fmt("> [!CAUTION] {}\n> {}", { i(1), i(0) })),
  s("!ABSTRACT", fmt("> [!ABSTRACT] {}\n> {}", { i(1), i(0) })),
  s("!SUMMARY", fmt("> [!SUMMARY] {}\n> {}", { i(1), i(0) })),
  s("!TLDR", fmt("> [!TLDR] {}\n> {}", { i(1), i(0) })),
  s("!INFO", fmt("> [!INFO] {}\n> {}", { i(1), i(0) })),
  s("!TODO", fmt("> [!TODO] {}\n> {}", { i(1), i(0) })),
  s("!HINT", fmt("> [!HINT] {}\n> {}", { i(1), i(0) })),
  s("!SUCCESS", fmt("> [!SUCCESS] {}\n> {}", { i(1), i(0) })),
  s("!CHECK", fmt("> [!CHECK] {}\n> {}", { i(1), i(0) })),
  s("!DONE", fmt("> [!DONE] {}\n> {}", { i(1), i(0) })),
  s("!QUESTION", fmt("> [!QUESTION] {}\n> {}", { i(1), i(0) })),
  s("!HELP", fmt("> [!HELP] {}\n> {}", { i(1), i(0) })),
  s("!FAQ", fmt("> [!FAQ] {}\n> {}", { i(1), i(0) })),
  s("!ATTENTION", fmt("> [!ATTENTION] {}\n> {}", { i(1), i(0) })),
  s("!FAILURE", fmt("> [!FAILURE] {}\n> {}", { i(1), i(0) })),
  s("!FAIL", fmt("> [!FAIL] {}\n> {}", { i(1), i(0) })),
  s("!MISSING", fmt("> [!MISSING] {}\n> {}", { i(1), i(0) })),
  s("!DANGER", fmt("> [!DANGER] {}\n> {}", { i(1), i(0) })),
  s("!ERROR", fmt("> [!ERROR] {}\n> {}", { i(1), i(0) })),
  s("!BUG", fmt("> [!BUG] {}\n> {}", { i(1), i(0) })),
  s("!EXAMPLE", fmt("> [!EXAMPLE] {}\n> {}", { i(1), i(0) })),
  s("!QUOTE", fmt("> [!QUOTE] {}\n> {}", { i(1), i(0) })),
  s("!CITE", fmt("> [!CITE] {}\n> {}", { i(1), i(0) })),
})
