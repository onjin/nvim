--- hover.nvim provider: shows constructors of the Java class under cursor.
---
--- Strategy:
---   1. textDocument/definition  → find the class source file
---   2. textDocument/documentSymbol → walk the symbol tree for constructors (kind=9)
return {
  name = "Java Constructors",
  priority = 999, -- below LSP (1000) and diagnostic (1001), so it appears last when cycling
  enabled = function(bufnr)
    return vim.bo[bufnr].filetype == "java"
  end,
  execute = function(params, done)
    local word = vim.fn.expand "<cword>"

    local pos = vim.api.nvim_win_get_cursor(0)
    local def_params = {
      textDocument = vim.lsp.util.make_text_document_params(params.bufnr),
      position = { line = pos[1] - 1, character = pos[2] },
    }

    -- Step 1: resolve where the class is defined
    vim.lsp.buf_request(params.bufnr, "textDocument/definition", def_params, function(err, result)
      if err or not result then
        return done(false)
      end

      local loc = vim.islist(result) and result[1] or result
      if not loc then
        return done(false)
      end

      local uri = loc.uri or loc.targetUri
      if not uri then
        return done(false)
      end

      -- derive the real class name from the definition file, not <cword>
      local class_name = uri:match "/([^/]+)%.java$" or word

      -- Step 2: get document symbols from the class file
      vim.lsp.buf_request(params.bufnr, "textDocument/documentSymbol", {
        textDocument = { uri = uri },
      }, function(err2, symbols)
        if err2 or not symbols then
          return done(false)
        end

        -- jdtls returns a hierarchical tree: class → children (methods, constructors…)
        local function collect_constructors(syms)
          local lines = {}
          for _, sym in ipairs(syms) do
            if sym.kind == 9 then -- Constructor
              table.insert(lines, "- `" .. sym.name .. "`")
            end
            if sym.children then
              vim.list_extend(lines, collect_constructors(sym.children))
            end
          end
          return lines
        end

        local lines = collect_constructors(symbols)

        if #lines == 0 then
          return done(false)
        end

        done {
          lines = vim.list_extend({ "## Constructors of `" .. class_name .. "`", "" }, lines),
          filetype = "markdown",
        }
      end)
    end)
  end,
}
