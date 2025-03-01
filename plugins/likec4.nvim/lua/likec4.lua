local likec4 = {}

function likec4.setup(options)
  -- Register filetype
  vim.filetype.add {
    extension = {
      c4 = "likec4",
    },
  }

  -- Syntax Highlighting
  vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
    pattern = "*.c4",
    callback = function()
      vim.cmd "set filetype=likec4"
      vim.bo.autoindent = true
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      -- Smart indent using 'indentexpr'
      vim.bo.indentexpr = "v:lua.LikeC4Indent()"

      vim.cmd [[
        set syntax=likec4
        " Keywords
        syntax keyword likec4Keyword specification model description technology autoLayout include exclude views view dynamic parallel color deployment
        syntax keyword likec4Keyword icon shape style link title nextgroup=likec4Variable skipwhite

        " Match user-defined elements (actor/system/component/database) after 'element'
        syntax match likec4Keyword "element " nextgroup=likec4Defined skipwhite
        syntax match likec4Keyword "deploymentNode " nextgroup=likec4Defined skipwhite
        syntax match likec4Keyword "tag " nextgroup=likec4Defined skipwhite
        syntax match likec4Defined "[a-zA-Z0-9_]*" display contained

        " Match variable names separately
        syntax match likec4Variable "[a-zA-Z_][a-zA-Z0-9_]*" display contained

        " var = element "
        syntax match likec4Var "^\s*[^=]\+="

        " Operators and Symbols
        syntax match likec4Operator "->"
        syntax match likec4Operator "<-"
        syntax match likec4Operator "="
        syntax match likec4Operator ":"
        syntax match likec4Parenthesis "[{}]"

        " Strings, Comments, and Tags
        syntax region likec4String start=+'+ end=+'+
        syntax region likec4String start=+"+ end=+"+
        syntax match likec4Comment "//.*$" contains=likec4Todo
        syntax match likec4Tag "#.*" skipwhite
        syntax keyword likec4Todo TODO FIXME contained

        " Highlighting rules
        highlight default likec4Keyword guifg=#c586c0
        highlight default likec4Defined guifg=#dcdcaa " Light yellow for dynamic elements
        highlight default likec4Parenthesis guifg=#ffd700
        highlight default likec4String guifg=#ce9178
        highlight default likec4Tag guifg=#4ec9b0
        highlight default likec4Variable guifg=#9cdcfe
        highlight default likec4Operator guifg=#dcdcaa
        highlight default likec4Comment guifg=#6a9955
        highlight default likec4Todo guifg=#ff0000
        highlight default likec4Var guifg=#4fc1ff
      ]]
    end,
  })
end

-- Define Custom Indentation Logic
function _G.LikeC4Indent()
  local line = vim.fn.getline(vim.v.lnum) -- Get current line
  local prev_line = vim.fn.getline(vim.v.lnum - 1) -- Get previous line

  -- Increase indent after '{'
  if prev_line:match "{%s*$" then
    return vim.bo.shiftwidth
  end

  -- Decrease indent after '}'
  if line:match "^%s*}" then
    return vim.bo.shiftwidth * -1
  end

  return 0
end

return likec4
