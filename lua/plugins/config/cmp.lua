return function()
    local cmp = require("cmp")

    local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
            return false
        end
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return text:sub(col, col):match("%s") == nil
    end

    local function jump_snippet(direction)
        if vim.snippet and vim.snippet.active({ direction = direction }) then
            vim.snippet.jump(direction)
            return true
        end
        return false
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                if vim.snippet then
                    vim.snippet.expand(args.body)
                elseif vim.fn.exists("*vsnip#anonymous") == 1 then
                    vim.fn["vsnip#anonymous"](args.body)
                else
                    vim.notify("No snippet engine configured for nvim-cmp", vim.log.levels.WARN)
                end
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-y>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif jump_snippet(1) then
                    return
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif jump_snippet(-1) then
                    return
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-x><C-o>"] = cmp.mapping(function()
                cmp.complete({
                    config = {
                        sources = {
                            { name = "nvim_lsp" },
                        },
                    },
                })
            end, { "i" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "buffer" },
            { name = "codeium" },
        }),
        experimental = {
            ghost_text = true,
        },
    })
end
