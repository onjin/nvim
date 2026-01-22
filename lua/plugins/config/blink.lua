local M = {}

local provider_cycle = {}
local provider_cycle_index = 0

local function configure_provider_cycle(definition)
    provider_cycle = definition or {}
    provider_cycle_index = #provider_cycle > 0 and 1 or 0
end

local function provider_cycle_label(entry)
    if entry.label then
        return entry.label
    end
    if entry.providers then
        return table.concat(entry.providers, ', ')
    end
    return 'All providers'
end

local function show_provider_cycle_entry(cmp, idx)
    local entry = provider_cycle[idx]
    if not entry then
        return false
    end
    provider_cycle_index = idx
    local opts = entry.providers and { providers = entry.providers } or nil
    if opts then
        cmp.show(opts)
    else
        cmp.show()
    end
    vim.notify(
        ('blink.cmp: %s'):format(provider_cycle_label(entry)),
        vim.log.levels.INFO,
        { title = 'Completion filter' }
    )
    return true
end

local function cycle_provider_filter(cmp, delta)
    if #provider_cycle == 0 then
        return true
    end
    local next_idx = ((provider_cycle_index - 1 + delta) % #provider_cycle) + 1
    return show_provider_cycle_entry(cmp, next_idx)
end

-- helper functions to split buffer completion between the focused buffer and every other listed buffer
local function current_buffer_only()
    return { vim.api.nvim_get_current_buf() }
end

local function other_listed_buffers()
    local current = vim.api.nvim_get_current_buf()
    local bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == '' then
            table.insert(bufs, buf)
        end
    end
    return bufs
end

-- sources priorities, bigger number means higher priority
score_offset = {
    lsp = 50,
    snippets = 20,
    codeium = 0,
    buffer_current = -5,
    buffer_other = -10,
    tmux = -15,
    env = -20,
    path = -25,

}

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
        keymap = {
            preset = 'default',
            ['<M-n>'] = {
                function(cmp)
                    return cycle_provider_filter(cmp, 1)
                end,
            },
            ['<M-p>'] = {
                function(cmp)
                    return cycle_provider_filter(cmp, -1)
                end,
            },
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
            default = { 'conventional_commits', 'lsp', 'snippets', 'buffer_current', 'buffer_other', 'path', 'env', 'tmux' },
            providers = {
                lsp = { score_offset = score_offset['lsp'] or 0 },
                snippets = { score_offset = score_offset['snippets'] or 0 },
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
                buffer_current = {
                    score_offset = score_offset['buffer_current'] or 0,
                    name = 'Buffer',
                    module = 'blink.cmp.sources.buffer',
                    opts = {
                        get_bufnrs = current_buffer_only,
                        get_search_bufnrs = current_buffer_only,
                    },
                },
                buffer_other = {
                    score_offset = score_offset['buffer_other'] or 0,
                    name = 'Other Buffers',
                    module = 'blink.cmp.sources.buffer',
                    enabled = function()
                        return #other_listed_buffers() > 0
                    end,
                    opts = {
                        get_bufnrs = other_listed_buffers,
                        get_search_bufnrs = other_listed_buffers,
                    },
                },
                tmux = {
                    score_offset = score_offset['tmux'] or 0,
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
                    score_offset = score_offset['env'] or 0,
                    name = "Env",
                    module = "blink-cmp-env",
                    --- @type blink-cmp-env.Options
                    opts = {
                        item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                        show_braces = false,
                        show_documentation_window = true,
                    },
                },
                path = {
                    score_offset = score_offset['path'] or 0,
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
        opts.sources.providers.codeium = {
            name = 'Codeium',
            module = 'codeium.blink',
            async = true,
            score_offset = score_offset['codeium'] or 0
        }
    end

    local provider_cycle_definition = {
        { label = 'All providers', providers = opts.sources.default },
        { label = 'LSP only',      providers = { 'lsp' } },
        { label = 'Snippets',      providers = { 'snippets' } },
    }
    if vim.g.ai_enabled then
        table.insert(provider_cycle_definition, { label = 'Codeium', providers = { 'codeium' } })
    end
    configure_provider_cycle(provider_cycle_definition)
    require('blink.cmp').setup(opts);
end

return M
