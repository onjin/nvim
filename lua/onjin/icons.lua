local M = {}

M.kinds = {
    Method = "",
    Function = "󰡱",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "",
    Property = "ﰠ",
    Interface = "",
    Enum = "",
    EnumMember = "",
    Reference = "",
    Struct = "",
    Event = "",
    Constant = "",
    Keyword = "",

    Module = "",
    Package = "",
    Namespace = "",

    Unit = "",
    Value = "",
    String = "",
    Number = "",
    Boolean = "",
    Array = "",
    Object = "",
    Key = "",
    Null = "",

    Text = "",
    Snippet = "",
    Color = "",
    File = "",
    Folder = "",
    Operator = "",
    TypeParameter = "",
}

M.kinds.spaced = setmetatable({}, {
    __index = function(_, key)
        return rawget(M.kinds, key) .. " "
    end,
})

M.diagnostics = {
    -- light = {
    -- 	errors = "",
    -- 	warnings = "",
    -- 	hints = "",
    -- 	info = "",
    -- },
    errors = "",
    warnings = "",
    hints = "",
    info = "",
}
M.diagnostics.Error = M.diagnostics.errors
M.diagnostics.Warn = M.diagnostics.warnings
M.diagnostics.Hint = M.diagnostics.hints
M.diagnostics.Info = M.diagnostics.info

M.lsp = {
    action_hint = "",
}

M.git = {
    diff = {
        added = " ",
        modified = "●",
        removed = "",
    },
    signs = {
        bar = "┃",
        untracked = "•",
    },
    branch = "",
    copilot = "",
}

M.dap = {
    stopped = "",
    running = "",
    paused = "",
    breakpoint = "",
}

M.actions = {
    close_hexagon = "",
    close2 = "⌧",
    close = "",
}

M.fold = {
    open = "",
    closed = "",
}

M.separators = {
    angle_quote = {
        left = "«",
        right = "»",
    },
    chevron = {
        left = "",
        right = "",
        down = "",
    },
    circle = {
        left = "",
        right = "",
    },
    arrow = {
        left = "",
        right = "",
    },
    slant = {
        left = "",
        right = "",
    },
}

M.misc = {
    modified = "●",
    newline = "﬋",
    circle = "",
    circle_filled = "",
    circle_slash = "",
    ellipse = "",
    kebab = "",
}

M.listchars_fancy = {
    space = " ",
    tab = "▸ ",
    eol = "¬",
    trail = "●",
    precedes = "«",
    extends = "»",
}
M.listchars_symbols = {
    space = " ",
    tab = "␋ ",
    eol = "␤",
    trail = "␠",
    precedes = "«",
    extends = "»",
}

M.listchars_plain = {
    space = " ",
    tab = ">-",
    eol = "$",
    trail = "~",
    extends = ">",
    precedes = "<",
}

M.available_listchars = {
    M.listchars_symbols,
    M.listchars_plain,
    M.listchars_fancy,
}
M.default_listchars = M.listchars_fancy

return M
