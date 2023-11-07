local onjin_config = require("onjin.config")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "romgrk/nvim-treesitter-context",
            "nvim-treesitter/playground",
        },
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = onjin_config.treesitter_initial_servers,
                highlight = {
                    enable = true,
                    use_languagetree = true,
                },
                indent = { enable = true },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                            ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                            ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                            ["am"] = { query = "@function.outer", desc = "Select outer part of a function/method" },
                            ["im"] = { query = "@function.inner", desc = "Select inner part of a function/method" },

                            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<localleader>na"] = "@parameter.inner",
                            ["<localleader>nm"] = "@function.outer",
                            ["<localleader>L"] = "@parameter.inner",
                            ["<localleader>J"] = "@function.outer",
                        },
                        swap_previous = {
                            ["<localleader>pa"] = "@parameter.inner",
                            ["<localleader>pm"] = "@function.outer",
                            ["<localleader>H"] = "@parameter.inner",
                            ["<localleader>K"] = "@function.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                            ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                            ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

                            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file for more queries.
                            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`.
                            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_next_end = {
                            ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                            ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                            ["]C"] = { query = "@class.outer", desc = "Next class end" },
                            ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                        },
                        goto_previous_start = {
                            ["[f"] = { query = "@call.outer", desc = "Previous function call start" },
                            ["[m"] = { query = "@function.outer", desc = "Previous method/function def start" },
                            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                            ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
                            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                        },
                        goto_previous_end = {
                            ["[F"] = { query = "@call.outer", desc = "Previous function call end" },
                            ["[M"] = { query = "@function.outer", desc = "Previous method/function def end" },
                            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                            ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
                            ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
                        },
                    },
                },
            })
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
        end,
    },
}
