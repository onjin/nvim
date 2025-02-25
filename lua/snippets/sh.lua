require("luasnip.session.snippet_collection").clear_snippets "sh"

local ls = require "luasnip"

local s = ls.snippet
-- local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("sh", {
  s("set#safe", fmt([[set -Eeuo pipefail]], {})),
  s("$script_dir", fmt([[script_dir=$(cd "$(dirname "${{BASH_SOURCE[0]}}")" &>/dev/null && pwd -P)]], {})),
  s(
    "trap#close",
    fmt(
      [[trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {{
    # script cleanup here
}}]],
      {}
    )
  ),
  s(
    "die",
    fmt(
      [[
      die() {{
        local msg=$1
        local code=${{2-1}} # default exit status 1
        msg "$msg"
        exit "$code"
      }}
    ]],
      {}
    )
  ),
  s(
    "setup_colors",
    fmt(
      [[
setup_colors() {{
  if test -t 2; then
    if test -z "${{NO_COLOR-}}"; then
        if test "${{TERM-}}" != "dumb"; then
            NC='\e[0m' RED='\e[31m' GREEN='\e[32m' ORANGE='\e[33m' BLUE='\e[34m' PURPLE='\e[35m' CYAN='\e[36m' YELLOW='\e[0;33m'
        else
            NC='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
        fi
    else
        NC='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
  else
      NC='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}}

msg() {{
  echo >&2 -e "${{1-}}"
}}

setup_colors
]],
      {}
    )
  ),
  s(
    "parse_params",
    fmt(
      [[
      parse_params() {{
        # default values of variables set from params
        flag=0
        param=''

        while :; do
          case "${{1-}}" in
          -h | --help) usage ;;
          -v | --verbose) set -x ;;
          --no-color) NO_COLOR=1 ;;
          -f | --flag) flag=1 ;; # example flag
          -p | --param) # example named parameter
            param="${{2-}}"
            shift
            ;;
          -?*) die "Unknown option: $1" ;;
          *) break ;;
          esac
          shift
        done

        args=("$@")

        # check required params and arguments
        if test -z "${{param-}}"; then
          die "Missing required parameter: param"
        fi
        if test ${{#args[@]}} -eq 0 ; then
          die "Missing script arguments"
        fi

        return 0
      }}

      parse_params "$@"
      ]],
      {}
    )
  ),
})
local text_types = {
  normal = 0,
  bold = 1,
  faint = 2,
  italics = 3,
  underline = 4,
}
local fg_colors = {
  black = 30,
  red = 31,
  green = 32,
  yellow = 33,
  blue = 34,
  magenta = 35,
  cyan = 36,
  light_gray = 37,
  gray = 90,
  light_red = 91,
  light_green = 92,
  light_yellow = 93,
  light_blue = 94,
  light_magenta = 95,
  light_cyan = 96,
  white = 97,
}
local bg_colors = {
  black = 40,
  red = 41,
  green = 43,
  yellow = 43,
  blue = 44,
  magenta = 45,
  cyan = 46,
  light_gray = 47,
  gray = 100,
  light_red = 101,
  light_green = 102,
  light_yellow = 103,
  light_blue = 104,
  light_magenta = 105,
  light_cyan = 106,
  white = 107,
}

local snippets = {}

-- create foreground color snippets like
-- - direct color code: GREEN -> '\\e[..'
-- - color code variable: GREEN= -> GREEN='\\e[..'
for color, color_code in pairs(fg_colors) do
  for text_type, text_type_code in pairs(text_types) do
    local suffix
    if text_type_code == 0 then
      suffix = ""
    else
      suffix = "_" .. string.upper(text_type)
    end
    local snippet_name = string.upper(color) .. suffix
    local escaped_code = "\\e[" .. text_type_code .. ";" .. color_code .. "m"

    -- inserts variable COLOR_TYPE='\e[...m'
    table.insert(snippets, s(snippet_name .. "=", fmt(snippet_name .. "='" .. escaped_code .. "'", {})))

    -- inserts color code directly
    table.insert(snippets, s(snippet_name, fmt(escaped_code, {})))
  end
end

-- create background color snippets like
-- - direct color code: GREEN_BG -> '\\e[..'
-- - color code variable: GREEN_BG= -> GREEN_BG='\\e[..'
for color, color_code in pairs(bg_colors) do
  local snippet_name = string.upper(color) .. "_BG"
  local escaped_code = "\\e[" .. color_code .. "m"

  -- inserts variable COLOR_TYPE='\e[...m'
  table.insert(snippets, s(snippet_name .. "=", fmt(snippet_name .. "='" .. escaped_code .. "'", {})))

  -- inserts color code directly
  table.insert(snippets, s(snippet_name, fmt(escaped_code, {})))
end

-- add no color variables
table.insert(snippets, s("NC", fmt("\\e[0m", {})))
table.insert(snippets, s("NC=", fmt("NC='\\e[0m'", {})))

ls.add_snippets("sh", snippets)
