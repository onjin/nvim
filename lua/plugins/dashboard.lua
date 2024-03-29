local config = require("config")

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
    local elements = {}
    table.insert(elements, string.format("Dir: %s", vim.fn.getcwd()))

    require("lazy.manage.checker").fast_check({ report = false })
    --[[
    local has_updates = require("lazy.status").has_updates()
    local updates = require("lazy.status").updates()

    if has_updates then
        table.insert(elements, string.format("Plugins: %s", updates))
    else
        table.insert(elements, "Plugins: up to date")
    end]]

    local static = Section:new({
        contents = function()
            return elements
        end,
        hl = "Normal",
    })

    require("veil").setup({
        sections = {
            --[[builtin.sections.animated(builtin.headers.frames_days_of_week[current_day], {
                hl = { fg = "#5de4c7" },
            }),]]
            static,
            builtin.sections.buttons({
                {
                    icon = "",
                    text = "Find Files",
                    shortcut = config.leader_key .. "ff",
                    callback = function()
                        vim.cmd("Telescope find_files")
                    end,
                },
                {
                    icon = "",
                    text = "Find Word",
                    shortcut = config.leader_key .. "fr",
                    callback = function()
                        vim.cmd("Telescope live_grep")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Files",
                    shortcut = config.leader_key .. "fb",
                    callback = function()
                        vim.cmd("Telescope file_browser")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Last Opened Files",
                    shortcut = config.leader_key .. "fo",
                    callback = function()
                        vim.cmd("Telescope oldfiles")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Projects",
                    shortcut = config.leader_key .. "p/",
                    callback = function()
                        vim.cmd("Telescope projects")
                    end,
                },
                {
                    icon = "",
                    text = "Browse Buffers",
                    shortcut = config.leader_key .. "b/",
                    callback = function()
                        vim.cmd("Telescope buffers")
                    end,
                },
                {
                    icon = "",
                    text = "Plugins manager (Lazy)",
                    shortcut = config.leader_key .. "p/",
                    callback = function()
                        vim.cmd("Lazy")
                    end,
                },
                {
                    icon = "",
                    text = "LSP manager (Mason)",
                    shortcut = config.leader_key .. "pl",
                    callback = function()
                        vim.cmd("Mason")
                    end,
                },
                {
                    icon = "",
                    text = "Browse NVIM Config Files",
                    shortcut = "<space>e",
                    callback = function()
                        edit_nvim()
                    end,
                },
            }),
            -- builtin.sections.oldfiles({ align = "left" }),
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
