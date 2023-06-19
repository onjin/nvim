local onjin_config = require("onjin.config")
local function edit_nvim()
    require("telescope.builtin").git_files({
        shorten_path = true,
        cwd = "~/.config/nvim",
        prompt = "~ nvim ~",
        height = 10,
        layout_strategy = "horizontal",
        layout_options = { preview_width = 0.75 },
    })
end

local config = function()
    local current_day = os.date("%A")
    local builtin = require("veil.builtin")
    local Section = require("veil.section")

    local static = Section:new({
        contents = function()
            return { "Current dir:", " - " .. vim.fn.getcwd() }
        end,
        hl = "Normal",
    })

    require("veil").setup({
        sections = {
            --[[
            builtin.sections.animated(builtin.headers.frames_days_of_week[current_day], {
                hl = { fg = "#5de4c7" },
            }),
            ]]
            static,
            builtin.sections.buttons({
                {
                    icon = "",
                    text = "Find Files",
                    shortcut = "<space>f",
                    callback = function()
                        vim.cmd("Telescope find_files")
                    end,
                },
                {
                    icon = "",
                    text = "Find Word",
                    shortcut = "<space>r",
                    callback = function()
                        vim.cmd("Telescope live_grep")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Files",
                    shortcut = "<space>c",
                    callback = function()
                        vim.cmd("Telescope file_browser")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Projects",
                    shortcut = "<space>p",
                    callback = function()
                        vim.cmd("Telescope projects")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Buffers",
                    shortcut = "<space>b",
                    callback = function()
                        vim.cmd("Telescope buffers")
                    end,
                },
                {
                    icon = "",
                    text = "Config",
                    shortcut = "<space>e",
                    callback = function()
                        edit_nvim()
                    end,
                },
            }),
            builtin.sections.oldfiles(),
        },
        mappings = {},
        startup = true,
        listed = false,
    })
end
return {
    {
        "willothy/veil.nvim",
        lazy = false,
        dependencies = {
            -- All optional, only required for the default setup.
            -- If you customize your config, these aren't necessary.
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = config,
        -- or configure with:
        -- opts = { ... }
    },
}
