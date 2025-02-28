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
        syntax keyword likec4Keyword specification element model tag
        syntax keyword likec4Keyword description technology style shape autoLayout include exclude view dynamic parallel

        syntax match likec4Operator "->"
        syntax match likec4Operator "<-"
        syntax match likec4Operator "="
        syntax match likec4Operator ":"
        syntax match likec4Parenthesis "{"
        syntax match likec4Parenthesis "}"

        syntax region likec4String start=+'+ end=+'+
        syntax region likec4String start=+"+ end=+"+
        syntax match likec4Comment "//.*$" contains=likec4Todo
        syntax match likec4Tag "#\w"
        syntax keyword likec4Todo TODO FIXME contained

        highligh default link likec4Keyword Keyword
        highlight default link likec4Operator Operator
        highlight default link likec4Parenthesis Delimiter
        highlight default link likec4String String
        highlight default link likec4Comment Comment
        highlight default link likec4Tag Special
        highlight default link likec4Todo Todo
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
