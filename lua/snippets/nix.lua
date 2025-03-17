require("luasnip.session.snippet_collection").clear_snippets "markdown"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("nix", {
  s("pkgs ? import <nixpkgs> ", fmt("pkgs ? import <nixpkgs>", {})),
  s(
    "pkgs ? import (unstable) ",
    fmt([[pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")]], {})
  ),
})
