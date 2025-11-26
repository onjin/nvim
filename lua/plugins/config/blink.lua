local M = {}
M.config = function()
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        signature = { enabled = true },
        keymap = { preset = 'default',
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = { auto_show = false },
            menu = {
                draw = {
                    -- for non LSP completion to also show icons
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                return kind_icon
                            end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        }
                    }
                }
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'conventional_commits', 'lsp', 'path', 'snippets', 'buffer', 'tmux', 'env' },
            providers = {
                conventional_commits = {
                    name = 'Conventional Commits',
                    module = 'blink-cmp-conventional-commits',
                    enabled = function()
                        return vim.bo.filetype == 'gitcommit'
                    end,
                    ---@module 'blink-cmp-conventional-commits'
                    ---@type blink-cmp-conventional-commits.Options
                    opts = {}, -- none so far
                },
                tmux = {
                    module = "blink-cmp-tmux",
                    name = "tmux",
                    -- default options
                    opts = {
                        all_panes = true,
                        capture_history = true,
                        -- only suggest completions from `tmux` if the `trigger_chars` are
                        -- used
                        triggered_only = false,
                        trigger_chars = { "." }
                    },
                },
                env = {
                    name = "Env",
                    module = "blink-cmp-env",
                    --- @type blink-cmp-env.Options
                    opts = {
                        item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                        show_braces = false,
                        show_documentation_window = true,
                    },
                }

            }
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
    }
    if vim.g.ai_enabled then
        table.insert(opts.sources.default, 'codeium')
        opts.sources.providers.codeium = { name = 'Codeium', module = 'codeium.blink', async = true }
    end
    require('blink.cmp').setup(opts);
end

return M
