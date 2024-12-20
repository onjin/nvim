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
            NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
        else
            NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
        fi
    else
        NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
  else
      NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
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
