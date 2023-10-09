if require("lazy.core.config").plugins["heirline.nvim"] then
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local catppuccin = require("catppuccin")
    local icons = require("onjin.icons")
    local misc_utils = require("utils")
    local colors = require("catppuccin.palettes").get_palette()
    local config = require("onjin.config")

    conditions.buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end

    conditions.hide_in_width = function(size)
        return vim.api.nvim_get_option("columns") > (size or 140)
    end

    local Align = { provider = "%=", hl = { bg = colors.crust } }
    local Space = { provider = " " }

    local VIMODE_COLORS = {
        ["n"] = colors.blue,
        ["no"] = colors.pink,
        ["nov"] = colors.pink,
        ["noV"] = colors.pink,
        ["no�"] = colors.pink,
        ["niI"] = colors.blue,
        ["niR"] = colors.blue,
        ["niV"] = colors.blue,
        ["v"] = colors.mauve,
        ["vs"] = colors.mauve,
        ["V"] = colors.lavender,
        ["Vs"] = colors.lavender,
        ["�"] = colors.yellow,
        ["�s"] = colors.yellow,
        ["s"] = colors.teal,
        ["S"] = colors.teal,
        ["�"] = colors.yellow,
        ["i"] = colors.green,
        ["ic"] = colors.green,
        ["ix"] = colors.green,
        ["R"] = colors.flamingo,
        ["Rc"] = colors.flamingo,
        ["Rv"] = colors.rosewater,
        ["Rx"] = colors.flamingo,
        ["c"] = colors.peach,
        ["cv"] = colors.peach,
        ["ce"] = colors.peach,
        ["r"] = colors.teal,
        ["rm"] = colors.sky,
        ["r?"] = colors.maroon,
        ["!"] = colors.maroon,
        ["t"] = colors.red,
        ["nt"] = colors.red,
        ["null"] = colors.pink,
    }
    local ViMode = {
        init = function(self)
            self.mode = vim.api.nvim_get_mode().mode
            if not self.once then
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:*o",
                    command = "redrawstatus",
                })
                self.once = true
            end
        end,
        static = {
            mode_names = {
                ["n"] = "NORMAL",
                ["no"] = "OP",
                ["nov"] = "OP",
                ["noV"] = "OP",
                ["no�"] = "OP",
                ["niI"] = "NORMAL",
                ["niR"] = "NORMAL",
                ["niV"] = "NORMAL",
                ["v"] = "VISUAL",
                ["vs"] = "VISUAL",
                ["V"] = "LINES",
                ["Vs"] = "LINES",
                ["�"] = "BLOCK",
                ["�s"] = "BLOCK",
                ["s"] = "SELECT",
                ["S"] = "SELECT",
                ["�"] = "BLOCK",
                ["i"] = "INSERT",
                ["ic"] = "INSERT",
                ["ix"] = "INSERT",
                ["R"] = "REPLACE",
                ["Rc"] = "REPLACE",
                ["Rv"] = "V-REPLACE",
                ["Rx"] = "REPLACE",
                ["c"] = "COMMAND",
                ["cv"] = "COMMAND",
                ["ce"] = "COMMAND",
                ["r"] = "ENTER",
                ["rm"] = "MORE",
                ["r?"] = "CONFIRM",
                ["!"] = "SHELL",
                ["t"] = "TERM",
                ["nt"] = "TERM",
                ["null"] = "NONE",
            },
        },
        provider = function(self)
            return string.format(" %s ", self.mode_names[self.mode])
        end,
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = VIMODE_COLORS[mode], bg = colors.mantle, bold = true }
        end,
        update = {
            "ModeChanged",
        },
    }
    local ViModeSepLeft = {
        init = function(self)
            self.mode = vim.api.nvim_get_mode().mode
            if not self.once then
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:*o",
                    command = "redrawstatus",
                })
                self.once = true
            end
        end,
        provider = "▍",
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = VIMODE_COLORS[mode], bg = colors.mantle }
        end,
        update = {
            "ModeChanged",
        },
    }
    local ViModeSepRight = {
        init = function(self)
            self.mode = vim.api.nvim_get_mode().mode
            if not self.once then
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:*o",
                    command = "redrawstatus",
                })
                self.once = true
            end
        end,
        provider = "▐",
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = VIMODE_COLORS[mode], bg = colors.mantle }
        end,
        update = {
            "ModeChanged",
        },
    }

    local ViModeArrow = {
        provider = "",
        hl = { fg = colors.mantle, bg = colors.crust },
    }

    local FileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
        condition = conditions.buffer_not_empty,
        hl = { bg = colors.crust, fg = colors.subtext1 },
    }

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
                vim.fn.fnamemodify(filename, ":t"),
                extension,
                { default = true }
            )
        end,
        provider = function(self)
            return self.icon and (" " .. self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    }

    local FileName = {
        provider = function(self)
            local filename = vim.fn.fnamemodify(self.filename, ":~:.")
            if filename == "" then
                return "[No Name]"
            end
            if not conditions.width_percent_below(#filename, 0.25) then
                filename = vim.fn.pathshorten(filename)
            end
            return filename
        end,
        hl = { fg = colors.subtext1, bold = true },
    }

    local FileFlags = {
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = " ● ",
            hl = { fg = colors.lavender },
        },
        {
            condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = "",
            hl = { fg = colors.red },
        },
    }

    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                return { fg = colors.text, bold = true, force = true }
            end
        end,
    }

    FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName),
        unpack(FileFlags),
        { provider = "%< " }
    )

    local FileType = {
        provider = function()
            return " " .. string.upper(vim.bo.filetype) .. " "
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
    }

    local FileSize = {
        provider = function()
            local suffix = { "b", "k", "M", "G", "T", "P", "E" }
            local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
            fsize = (fsize < 0 and 0) or fsize
            if fsize < 1024 then
                return " " .. fsize .. suffix[1] .. " "
            end
            local i = math.floor((math.log(fsize) / math.log(1024)))
            return string.format(" %.2g%s ", fsize / math.pow(1024, i), suffix[i + 1])
        end,
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
    }

    local Ruler = {
        provider = " %7(%l/%3L%):%2c %P ",
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
    }
    local LazyStatus = {
        condition = function()
            return require("lazy.status").has_updates()
        end,
        provider = function()
            return string.format("%s", require("lazy.status").updates())
        end,
        on_click = {
            callback = function()
                vim.defer_fn(function()
                    vim.cmd("Lazy")
                end, 100)
            end,
            name = "heirline_LSP",
        },
        hl = { bg = colors.crust, fg = "" },
    }

    local LSPProgress = {
        condition = function()
            return conditions.hide_in_width(120) and conditions.lsp_attached()
        end,
        update = { "User LspProgressStatusUpdated" },
        provider = function()
            local progress = require("lsp-progress").progress({
                format = function(messages)
                    return #messages > 0 and table.concat(messages, " ") or ""
                end,
            })
            return " " .. progress .. " "
        end,
        hl = { bg = colors.crust, fg = colors.subtext1, bold = true, italic = false },
    }

    local LSPActive = {
        condition = function()
            return conditions.hide_in_width(120) and conditions.lsp_attached()
        end,
        update = { "LspAttach", "LspDetach" },
        provider = function()
            local names = {}
            for _, server in pairs(vim.lsp.get_active_clients()) do
                if server.name ~= "null-ls" then
                    table.insert(names, server.name)
                end
            end
            local nr_of_names = misc_utils.tablelength(names)
            local prefix = config.status_lsp_prefix or icons.misc.cog
            if config.status_lsp_show_server_names then
                return " " .. prefix .. " " .. table.concat(names, " ") .. " "
            else
                return " " .. prefix .. " [" .. nr_of_names .. "] "
            end
        end,
        hl = { bg = colors.crust, fg = colors.subtext1, bold = true, italic = false },
        on_click = {
            callback = function()
                vim.defer_fn(function()
                    vim.cmd("LspInfo")
                end, 100)
            end,
            name = "heirline_LSP",
        },
    }
    local Diagnostics = {
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width() and conditions.has_diagnostics()
        end,
        static = {
            error_icon = icons.diagnostics.errors .. " ",
            warn_icon = icons.diagnostics.warnings .. " ",
            info_icon = icons.diagnostics.info .. " ",
            hint_icon = icons.diagnostics.hints .. " ",
        },
        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        hl = { bg = colors.crust },
        Space,
        {
            provider = function(self)
                return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = { fg = colors.red },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            end,
            hl = { fg = colors.yellow },
        },
        {
            provider = function(self)
                return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = { fg = colors.sapphire },
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = colors.sky },
        },
        Space,
    }
    local head_cache = {}

    local function get_git_detached_head()
        local git_branches_file = io.popen("git branch -a --no-abbrev --contains", "r")
        if not git_branches_file then
            return
        end
        local git_branches_data = git_branches_file:read("*l")
        io.close(git_branches_file)
        if not git_branches_data then
            return
        end

        local branch_name = git_branches_data:match(".*HEAD (detached %w+ [%w/-]+)")
        if branch_name and string.len(branch_name) > 0 then
            return branch_name
        end
    end

    local function parent_pathname(path)
        local i = path:find("[\\/:][^\\/:]*$")
        if not i then
            return
        end
        return path:sub(1, i - 1)
    end

    local function get_git_dir(path)
        local function has_git_dir(dir)
            local git_dir = dir .. "/.git"
            if vim.fn.isdirectory(git_dir) == 1 then
                return git_dir
            end
        end

        local function has_git_file(dir)
            local gitfile = io.open(dir .. "/.git")
            if gitfile ~= nil then
                local git_dir = gitfile:read():match("gitdir: (.*)")
                gitfile:close()

                return git_dir
            end
        end

        local function is_path_absolute(dir)
            local patterns = {
                "^/",
                "^%a:[/\\]",
            }
            for _, pattern in ipairs(patterns) do
                if string.find(dir, pattern) then
                    return true
                end
            end
            return false
        end

        if not path or path == "." then
            path = vim.fn.getcwd()
        end

        local git_dir
        while path do
            git_dir = has_git_dir(path) or has_git_file(path)
            if git_dir ~= nil then
                break
            end
            path = parent_pathname(path)
        end

        if not git_dir then
            return
        end

        if is_path_absolute(git_dir) then
            return git_dir
        end
        return path .. "/" .. git_dir
    end

    local Git = {
        condition = function()
            return conditions.buffer_not_empty() and conditions.is_git_repo()
        end,
        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0
                or self.status_dict.removed ~= 0
                or self.status_dict.changed ~= 0
        end,
        hl = { bg = colors.mantle, fg = colors.mauve },
        Space,
        {
            provider = function()
                if vim.bo.filetype == "help" then
                    return
                end
                local current_file = vim.fn.expand("%:p")
                local current_dir

                if vim.fn.getftype(current_file) == "link" then
                    local real_file = vim.fn.resolve(current_file)
                    current_dir = vim.fn.fnamemodify(real_file, ":h")
                else
                    current_dir = vim.fn.expand("%:p:h")
                end

                local git_dir = get_git_dir(current_dir)
                if not git_dir then
                    return
                end

                local git_root = git_dir:gsub("/.git/?$", "")
                local head_stat = vim.loop.fs_stat(git_dir .. "/HEAD")

                if head_stat and head_stat.mtime then
                    if
                        head_cache[git_root]
                        and head_cache[git_root].mtime == head_stat.mtime.sec
                        and head_cache[git_root].branch
                    then
                        return " " .. head_cache[git_root].branch
                    else
                        local head_file = vim.loop.fs_open(git_dir .. "/HEAD", "r", 438)
                        if not head_file then
                            return
                        end
                        local head_data = vim.loop.fs_read(head_file, head_stat.size, 0)
                        if not head_data then
                            return
                        end
                        vim.loop.fs_close(head_file)

                        head_cache[git_root] = {
                            head = head_data,
                            mtime = head_stat.mtime.sec,
                        }
                    end
                else
                    return
                end

                local branch_name = head_cache[git_root].head:match("ref: refs/heads/([^\n\r%s]+)")
                if not branch_name then
                    branch_name = get_git_detached_head()
                    if not branch_name then
                        head_cache[git_root].branch = ""
                        return
                    end
                end

                head_cache[git_root].branch = branch_name
                return " " .. branch_name
            end,
            hl = { bold = true },
        },
        {
            provider = function(self)
                local count = self.status_dict.added or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.green },
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.red },
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.peach },
        },
        Space,
    }

    local GitArrow = {
        provider = "",
        hl = { fg = colors.mantle, bg = colors.crust },
        condition = function()
            return conditions.buffer_not_empty() and conditions.is_git_repo()
        end,
    }

    local FileEncoding = {
        provider = function()
            local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
            return " " .. enc:upper() .. " "
        end,
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
    }

    local FileFormat = {
        provider = function()
            local fmt = vim.bo.fileformat
            if fmt == "unix" then
                return " LF "
            elseif fmt == "mac" then
                return " CR "
            else
                return " CRLF "
            end
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
    }

    local IndentSizes = {
        provider = function()
            local indent_type = vim.api.nvim_buf_get_option(0, "expandtab") and "Spaces" or "Tab Size"
            local indent_size = vim.api.nvim_buf_get_option(0, "tabstop")
            return (" %s: %s "):format(indent_type, indent_size)
        end,
        hl = { bg = colors.crust, fg = colors.surface2 },
        condition = function()
            return conditions.buffer_not_empty() and conditions.hide_in_width()
        end,
    }

    local BufferlineFileName = {
        provider = function(self)
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
        end,
        hl = function(self)
            return {
                fg = colors.text,
                bold = self.is_active or self.is_visible,
                italic = false,
            }
        end,
    }

    local BufferlineFileFlags = {
        {
            provider = function(self)
                return vim.api.nvim_buf_get_option(self.bufnr, "modified") and " ● " or "   "
            end,
            hl = { fg = colors.text },
        },
        {
            condition = function(self)
                return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                    or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
            end,
            provider = function(self)
                if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                    return "  "
                else
                    return "  "
                end
            end,
            hl = { fg = colors.peach },
        },
    }
    local TablineBufnr = {
        provider = function(self)
            return tostring(self.bufnr) .. ". "
        end,
        hl = "Comment",
    }

    local BufferlineFileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
                vim.fn.fnamemodify(filename, ":t"),
                extension,
                { default = true }
            )
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    }
    -- a nice "x" button to close the buffer
    local TablineCloseButton = {
        condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        { provider = " " },
        {
            provider = "",
            hl = { fg = "gray" },
            on_click = {
                callback = function(_, minwid)
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(minwid, { force = false })
                        vim.cmd.redrawtabline()
                    end)
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_close_buffer_callback",
            },
        },
    }
    -- allow to jump to buffer by 'gbX' where 'X' is first available letter of buffer file name
    local TablinePicker = {
        condition = function(self)
            return self._show_picker
        end,
        init = function(self)
            local bufname = vim.api.nvim_buf_get_name(self.bufnr)
            bufname = vim.fn.fnamemodify(bufname, ":t")
            local label = bufname:sub(1, 1)
            local i = 2
            while self._picker_labels[label] do
                if i > #bufname then
                    break
                end
                label = bufname:sub(i, i)
                i = i + 1
            end
            self._picker_labels[label] = self.bufnr
            self.label = label .. " "
        end,
        provider = function(self)
            return self.label
        end,
        hl = { fg = "red", bold = true },
    }

    local BufferlineFileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
            if self.is_active then
                local background = catppuccin.options.transparent_background and "NONE" or colors.base
                return { bg = background }
            else
                return { bg = colors.surface0 }
            end
        end,
        on_click = {
            callback = function(_, minwid)
                vim.api.nvim_win_set_buf(0, minwid)
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_buffer_callback",
        },
        { provider = "   " },
        TablinePicker,
        -- TablineBufnr,
        BufferlineFileIcon,
        BufferlineFileName,
        BufferlineFileFlags,
        TablineCloseButton,
    }

    local BufferLine = utils.make_buflist(
        BufferlineFileNameBlock,
        { provider = "  ", hl = { fg = colors.text } },
        { provider = "  ", hl = { fg = colors.text } }
    )

    local Tabpage = {
        provider = function(self)
            return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
        end,
        hl = function(self)
            if self.is_active then
                return { bg = colors.base, bold = true }
            else
                return { bg = colors.surface0 }
            end
        end,
    }

    local TabPages = {
        condition = function()
            return #vim.api.nvim_list_tabpages() >= 2
        end,
        { provider = "%=", hl = { bg = colors.crust } },
        utils.make_tablist(Tabpage),
    }

    local TabLineOffset = {
        condition = function(self)
            local win = vim.api.nvim_tabpage_list_wins(0)[1]
            local bufnr = vim.api.nvim_win_get_buf(win)
            self.winid = win

            if vim.bo[bufnr].filetype == "NvimTree" then
                return true
            end
        end,
        provider = function(self)
            local width = vim.api.nvim_win_get_width(self.winid)
            return string.rep(" ", width)
        end,
        hl = "NvimTreeNormal",
    }

    local StatusLine = {
        ViModeSepLeft,
        ViMode,
        ViModeArrow,
        FileNameBlock,
        FileType,
        FileSize,
        Ruler,
        Align,
        LSPActive,
        LSPProgress,
        LazyStatus,
        Diagnostics,
        FileEncoding,
        FileFormat,
        IndentSizes,
        GitArrow,
        Git,
        ViModeSepRight,
    }

    local TabLine = { TabLineOffset, BufferLine, Align, TabPages }

    local heirline = require("heirline")
    heirline.setup({ statusline = StatusLine, winbar = nil, tabline = TabLine })
end
if require("lazy.core.config").plugins["lualine.nvim"] then
    local lualine = require("lualine")

    -- context from treesitter
    local current_treesitter_context = function()
        local f = require("nvim-treesitter").statusline({
            indicator_size = 300,
            type_patterns = {
                "class",
                "function",
                "method",
                "interface",
                "type_spec",
                "table",
                "if_statement",
                "for_statement",
                "for_in_statement",
            },
        })
        local fun_name = string.format("%s", f) -- convert to string, it may be a empty ts node

        if fun_name == "vim.NIL" then
            return " "
        end
        return " " .. fun_name
    end

    local function get_short_cwd()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        -- return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
    end

    local function LspSign()
        return require("lsp-progress").progress({
            format = function(messages)
                return " LSP"
            end,
        })
    end

    local function LspStatus()
        return require("lsp-progress").progress({
            format = function(messages)
                return #messages > 0 and table.concat(messages, " ") or ""
            end,
        })
    end

    local options = {
        options = {
            icons_enabled = true,
            theme = "catppuccin",

            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                -- sets how often lualine should refreash it's contents (in ms)
                statusline = 1000, -- The refresh option sets minimum time that lualine tries
                tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
                winbar = 1000, -- arises that lualine needs to refresh itself before this time
                -- it'll do it.

                -- Also you can force lualine's refresh by calling refresh function
                -- like require('lualine').refresh()
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
                get_short_cwd,
                {
                    function()
                        local cur_buf = vim.api.nvim_get_current_buf()
                        return require("hbac.state").is_pinned(cur_buf) and "📍" or ""
                        -- tip: nerd fonts have pinned/unpinned icons!
                    end,
                    color = { fg = "#ef5f6b", gui = "bold" },
                    "filename",
                },
            },
            lualine_x = { LspStatus, LspSign, "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { "buffers", mode = 2 } },
            lualine_z = { "tabs" },
        },
        --[[winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {"diff", separator = '|'},
        {"filename", separator = '|'},
        {"filetype", separator ='|'},
      },
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {"diff", separator = '|'},
        {"filename", separator = '|'},
        {"filetype", separator ='|'},
      },
    },]]
        extensions = {},
    }

    lualine.setup(options)
    -- refresh lualine
    vim.cmd([[
    augroup lualine_augroup
        autocmd!
        autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
    augroup END
    ]])
end
