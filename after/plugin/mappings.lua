-- luacheck: globals vim
if vim.g.minimal then
    return
end

-- helper functions {{{
local home = os.getenv("HOME")

local F = {}
function F.edit_nvim()
    require("telescope.builtin").git_files({
        shorten_path = true,
        cwd = "~/.config/nvim",
        prompt = "~ nvim ~",
        height = 10,
        layout_strategy = "horizontal",
        layout_options = { preview_width = 0.75 },
    })
end

local wk = require("which-key")

local function register(modes, mappings, opts, palette)
    if type(modes) == "table" then
        for _, mode in ipairs(modes) do
            wk.register(mappings, vim.tbl_deep_extend("keep", { mode = mode }, opts or {}))
        end
    else
        wk.register(mappings, vim.tbl_deep_extend("keep", { mode = modes }, opts or {}))
    end
end

local function nop(key)
    vim.keymap.set({ "n" }, key, "<nop>", { noremap = true })
end
-- helper functions }}}

-- normal mode shortcuts CTRL {{{
register("n", {
    ["<C-S-P>"] = { "<cmd>Legendary<CR>", "  Commands Palette" },
})
-- normal mode shortcuts CTRL }}}

-- insert mode movements {{{
register("i", {
    ["<C-b>"] = { "<ESC>^i", "󰘴  beginning of line" },
    ["<C-e>"] = { "<End>", " end of line" },
    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "  move left" },
    ["<C-l>"] = { "<Right>", "  move right" },
    ["<C-j>"] = { "<Down>", "  move down" },
    ["<C-k>"] = { "<Up>", "  move up" },
})
-- insert mode movements }}}

-- generic movements/ESC {{{
register("n", {
    ["<ESC>"] = { "<cmd> noh <CR>", "󰙒  no highlight" },
    -- switch between windows
    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "  save file" },
    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },
    -- line numbers
    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
})
-- generic movements/ESC }}}

-- terminal movements {{{
register("t", {
    ["<C-x>"] = { [[<C-\><C-n>]], opts = { buffer = 0 }, "   escape terminal mode" },
    ["<C-h>"] = { [[<Cmd>wincmd h<CR>]], opts = { buffer = 0 } },
    ["<C-j>"] = { [[<Cmd>wincmd j<CR>]], opts = { buffer = 0 } },
    ["<C-k>"] = { [[<Cmd>wincmd k<CR>]], opts = { buffer = 0 } },
    ["<C-l>"] = { [[<Cmd>wincmd l<CR>]], opts = { buffer = 0 } },
})
-- terminal movements }}}

-- visual mode movements {{{
register("v", {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
    -- allow to use `.` on visual selections
    ["."] = { ":norm.<CR>" },
})
-- visual mode movements }}}

-- lsp g/K {{{
register("n", {
    ["gD"] = {
        function()
            vim.lsp.buf.declaration()
        end,
        "   lsp declaration",
    },
    ["gd"] = { "<cmd>Lspsaga goto_definition<CR>", "  LSP Goto definition" },
    ["gp"] = { "<cmd>Lspsaga peek_definition<CR>", "  LSP Peek definition" },
    ["K"] = { "<cmd>Lspsaga hover_doc<CR>", "   lsp hover" },
    ["gi"] = {
        function()
            -- vim.lsp.buf.implementation()
            require("telescope.builtin").lsp_implementations()
        end,
        "   lsp implementation",
    },
    ["gr"] = {
        -- function()
        -- 	require("telescope.builtin").lsp_references()
        -- end,
        "<cmd>Lspsaga finder<CR>",
        "   lsp references",
    },
    ["gs"] = {
        function()
            -- vim.lsp.buf.references()
            require("telescope.builtin").lsp_document_symbols()
        end,
        "   lsp document symbols",
    },
    ["gb"] = {
        function()
            local tabline = require("heirline").tabline
            local buflist = tabline._buflist[1]
            buflist._picker_labels = {}
            buflist._show_picker = true
            vim.cmd.redrawtabline()
            local char = vim.fn.getcharstr()
            local bufnr = buflist._picker_labels[char]
            if bufnr then
                vim.api.nvim_win_set_buf(0, bufnr)
            end
            buflist._show_picker = false
            vim.cmd.redrawtabline()
        end,
        "Go buffer by letter",
    },
})
-- lsp g/K }}}(

-- <leader> a - +Applications {{{

-- vimux
register("n", {
    ["<leader>a"] = { name = "+Applications" },
    ["<leader>ag"] = { ':call VimuxRunCommand("clear; glow " . bufname("%"))<CR>', "Preview markdown buffer in glow" },

    ["<leader>am"] = { name = "+Markdown" },
    ["<leader>amt"] = { "<cmd>MarkdownPreviewToggle<CR>", "Toggle Markdown Preview" },
    ["<leader>ams"] = { "<cmd>MarkdownPreviewStop<CR>", "Stop Markdown Preview" },
    ["<leader>amp"] = { "<cmd>MarkdownPreview<CR>", "Start Markdown Preview" },

    ["<leader>at"] = { name = "+Todo" },
    ["<leader>at/"] = { "<cmd>TodoTelescope<cr>", "Search for TODO marks" },
    ["<leader>atq"] = { "<cmd>TodoQuickFix<cr>", "Fill quickfix with TODO marks" },
    ["<leader>atl"] = { "<cmd>TodoLocList<cr>", "Fill loclist with TODO marks" },
})
-- <leader> a - +Applications }}}

-- <leader> b - +Buffers prefix {{{
register("n", {
    ["<TAB>"] = { "<cmd> :bn <CR>", "  goto next buffer" },
    ["<S-Tab>"] = { "<cmd> :bp <CR> ", "  goto prev buffer" },

    ["<leader>b"] = { name = "+Buffers" },
    ["<leader>b/"] = { "<cmd> Telescope buffers <CR>", "Open buffer picker" },
    ["<leader>bc"] = { "<cmd>lua require('hbac').close_unpinned()<CR>", "Close unpinned buffers" },
    ["<leader>bn"] = { "<cmd> enew <CR>", " new buffer" },
    ["<leader>bx"] = { "<cmd> :bd <CR>", "󰆴 close buffer" },
    ["<leader>bX"] = { "<cmd> :BClose menu<CR>", "󰗩 buffers delete menu" },
})
-- <leader> b - +Buffers prefix }}}

-- <leader> d - +Diagnostics prefix {{{
register("n", {
    ["<leader>d"] = { name = "+Diagnostics" },
    ["<leader>ds"] = { ":lua vim.diagnostic.show(nil, 0)<cr>", "  Show diagnostic (buf)" },
    ["<leader>dh"] = { ":lua vim.diagnostic.hide(nil, 0)<cr>", "  Hide diagnostic (buf)" },
    ["<leader>dd"] = { ":lua vim.diagnostic.disable(0)<cr>", "  Disable diagnostic (buf)" },
    ["<leader>de"] = { ":lua vim.diagnostic.enable(0)<cr>", "  Enable diagnostic (buf)" },
    ["<leader>dl"] = {
        function()
            vim.diagnostic.setloclist()
        end,
        "   diagnostic setloclist",
    },
})
-- <leader> d - +Diagnostics prefix }}}

-- <leader> f - +Files prefix {{{
register("n", {
    ["<leader>f"] = { name = "+Files" },

    ["<leader>f/"] = { "<cmd> Telescope find_files <CR>", "  find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
    ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "  find files" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "󰋖  help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "  find oldfiles" },
    ["<leader>fr"] = { "<cmd> Telescope live_grep <CR>", "  live grep" },
    ["<leader>fs"] = { "<cmd>:lua require('spectacle').SpectacleTelescope()<CR>", "  pick saved session to load" },
    ["<leader>fb"] = { "<cmd> Telescope file_browser <CR>", "  open file browser" },

    ["<leader>fg"] = { name = "+Git" },
    ["<leader>fg/"] = { "<cmd> Telescope git_files <CR>", "  Fuzzy search git files" },
    ["<leader>fgf"] = { "<cmd> Telescope git_files <CR>", "  Fuzzy search git files" },
    ["<leader>fgb"] = { "<cmd> Telescope git_branches <CR>", "  git branches" },
    ["<leader>fgc"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
    ["<leader>fgo"] = { "<cmd> Telescope git_bcommits <CR>", "  git buffer commits" },
    ["<leader>fgs"] = { "<cmd> Telescope git_status <CR>", "  git status" },
    ["<leader>fgt"] = { "<cmd> Telescope git_stash <CR>", "  git stash" },

    ["<leader>fw"] = { name = "+Workspaces" },
    ["<leader>fwa"] = {
        function()
            vim.lsp.buf.add_workspace_folder()
        end,
        "  add workspace folder",
    },
    ["<leader>fwr"] = {
        function()
            vim.lsp.buf.remove_workspace_folder()
        end,
        "  remove workspace folder",
    },
    ["<leader>fwl"] = {
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        "  list workspace folders",
    },
})

-- <leader> f - +Files prefix }}}

-- <leader> h - +Help prefix {{{
register("n", {
    ["<leader>h"] = { name = "+Help" },

    ["<leader>hK"] = {
        function()
            vim.cmd("WhichKey")
        end,
        "   which-key all keymaps",
    },
    ["<leader>hk"] = {
        function()
            local input = vim.fn.input("WhichKey: ")
            vim.cmd("WhichKey " .. input)
        end,
        "   which-key query lookup",
    },
    ["<leader>hm"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },

    ["<leader>hla"] = { "<cmd>Legendary autocmds<CR>", "   Auto commands legend" },
    ["<leader>hlc"] = { "<cmd>Legendary commands<CR>", "   Commands legend" },
    ["<leader>hlf"] = { "<cmd>Legendary functions<CR>", "   Functions legend" },
    ["<leader>hlk"] = { "<cmd>Legendary keymaps<CR>", "   Keymaps legend" },
})
-- <leader> h - +Help prefix }}}

-- <leader> j - +Jump prefix {{{
register("n", {
    ["<leader>j"] = { name = "+Jump" },
    ["<leader>jc"] = {
        function()
            require("treesitter-context").go_to_context(vim.v.count1)
        end,

        "  Jump to current_context",
    },
})
-- <leader> j - +Jump prefix }}}

-- <leader> l - +LSP prefix {{{
register("n", {
    ["<leader>l"] = { name = "+LSP" },

    ["<leader>la"] = { "<cmd>Lspsaga code_action<CR>", "  LSP Code Action" },
    ["<leader>ld"] = { "<cmd>Lspsaga show_line_diagnostics<CR>", "  LSP Floating Diagnostic" },
    ["<leader>lf"] = {
        function()
            vim.lsp.buf.format({ async = true })
        end,
        "  LSP Code Format",
    },
    ["<leader>ln"] = { "<cmd>Navbuddy<CR>", "Code navigation popup" },
    ["<leader>lo"] = { "<cmd>Lspsaga outline<CR>", "  LSP Toggle Outline" },
    ["<leader>lr"] = { "<cmd>Lspsaga lsp_finder<CR>", "  LSP Find References" },
    ["<leader>lt"] = {
        function()
            -- vim.lsp.buf.type_definition()
            require("telescope.builtin").lsp_type_definitions()
        end,
        "  LSP definition type",
    },
    ["<leader>lR"] = { "<cmd>Lspsaga rename<CR>", "  LSP Rename" },
})
-- <leader> l - +LSP prefix }}}

-- <leader> p - +Projects/Packages prefix {{{
register("n", {
    ["<leader>p"] = { name = "+Projects/Packages" },

    ["<leader>pp"] = { "<cmd>Lazy<cr>", "Plugins list" },
    ["<leader>pl"] = { "<cmd>Mason<cr>", "LSP Servers list" },
    ["<leader>p/"] = { "<cmd> Telescope projects <CR>", "Browse projects" },
})
-- <leader> p - +Projects/Packages prefix }}}

-- <leader> r - +Registers prefix {{{
register("n", {
    ["<leader>r"] = { name = "+Registers" },

    ["<leader>rp"] = { "*pp", "paste from *pp" },
})
-- <leader> r - +Registers prefix }}}

-- <leader> s - +Substitutions prefix {{{
register("n", {
    ["<leader>ss"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },
})
-- <leader> s - +Substitutions prefix }}}

-- <leader> t - +Toggles prefix {{{
register("n", {
    ["<leader>t"] = { name = "+Toggles" },

    ["<leader>tb"] = { ":lua require('blam').toggle()<cr>", "  Toggle Git Blame" },
    ["<leader>tc"] = {
        ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>",
        "Toggle Conceal Level (listchars)",
    },
    ["<leader>tn"] = { "<cmd> set nu! <CR>", "   Toggle Line Numbers" },
    ["<leader>tp"] = { "<cmd>lua require('hbac').toggle_pin()<CR>", "Toggle Buffer Pin" },
    ["<leader>tr"] = { "<cmd> set rnu! <CR>", "   Toggle Relative Number" },
    ["<leader>tt"] = { ":lua require('treesitter-context').toggle()<CR>", "   Toggle TreeSitter Context" },

    ["<leader>T"] = { name = "+UI Toggles/Themes" },
    ["<leader>T1"] = { ":vertical resize 80<cr>", "Resize buffer width to 80" },
    ["<leader>T2"] = { ":vertical resize 120<cr>", "Resize buffer width to 120" },
    ["<leader>Tc"] = { "<cmd> Telescope colorscheme <CR>", "  Browse themes" },
    ["<leader>Tl"] = {
        function()
            vim.cmd("CycleListchars")
        end,
        "␋ Cycle listchars themes",
    },
})
-- <leader> t - +Toggles prefix }}}

-- <leader> u - +Utils prefix {{{
register("n", {
    ["<leader>u"] = { name = "+Utils" },
    ["<leader>uh"] = { "<cmd>:lua require('based').convert()<cr>", "Convert to/from hex" },
})
-- <leader> u - +Utils prefix }}}

-- <leader> w - +Windows {{{

-- vimux
register("n", {
    ["<leader>w"] = { name = "+Windows" },

    ["<leader>wz"] = { "<cmd>NeoZoomToggle<cr>", "Zoom toggle" },

    ["<leader>wv"] = { name = "+Vimux" },
    ["<leader>wvi"] = { ":VimuxInspectRunner<cr>", "~ Inspect vimux runner" },
    ["<leader>wvo"] = { ":VimuxOpenRunner<cr>", "~ Open vimux runner" },
    ["<leader>wvp"] = { ":VimuxPromptCommand<cr>", "~ Run prompted command in vimux runner" },
    ["<leader>wvq"] = { ":VimuxCloseRunner<cr>", "~ Close vimux runner" },
    ["<leader>wvx"] = { ":VimuxInterruptRunner<cr>", "~ Interrupt vimux runner process" },
    ["<leader>wvz"] = { ":VimuxZoomRunner<cr>", "~ Zoom vimux runner" },
    ["<leader>wv<C-l>"] = { ":VimuxClearTerminalScreen<cr>", "~ Clear screen of vimux runner" },
})

-- execute
register("n", {
    ["<leader>x"] = { name = "+Execute" },
    ["<leader>xr"] = { ":call VrcQuery()<CR>", "~ Execute REST call" },
})
-- <leader> w - +Windows }}}

-- <localleader> c - +Context/Cargo prefix {{{
register("n", {
    ["<localleader>c"] = { name = "+Cargo" },
    ["<localleader>ca"] = { ":lua require('crates').update_all_crates()<cr>", "[Cargo] update all" },
    ["<localleader>cd"] = { ":lua require('crates').show_dependencies_popup()<cr>", "[Cargo] show dependencies" },
    ["<localleader>cf"] = { ":lua require('crates').show_features_popup()<cr>", "[Cargo] show features" },
    ["<localleader>cr"] = { ":lua require('crates').reload()<cr>", "[Cargo] reload" },
    ["<localleader>ct"] = { ":lua require('crates').toggle()<cr>", "[Cargo] toggle" },
    ["<localleader>cu"] = { ":lua require('crates').update_crate()<cr>", "[Cargo] update crate" },
    ["<localleader>cv"] = { ":lua require('crates').show_versions_popup()<cr>", "[Cargo] show versions" },
    ["<localleader>cA"] = { ":lua require('crates').upgrade_all_crates()<cr>", "[Cargo] upgrade all" },
    ["<localleader>cC"] = { ":lua require('crates').focus_popup()<cr>", "[Cargo] focus popup" },
    ["<localleader>cU"] = { ":lua require('crates').upgrade_crate()<cr>", "[Cargo] upgrade crate" },
})
register("v", {
    ["<localleader>cu"] = { ":lua require('crates').update_crates()<cr>", "[Cargo] update crates" },
    ["<localleader>cU"] = { ":lua require('crates').upgrade_crates()<cr>", "[Cargo] upgrade crates" },
})
-- <localleader> c - +Context/Cargo prefix }}}

-- <localleader> g - +GitSigns prefix {{{
register("n", {
    ["<localleader>g"] = { "+GitSigns" },

    ["<localleader>gb"] = {
        function()
            require("blam").peek()
        end,
        "  blame line",
    },
    ["<localleader>gd"] = { ":lua require('gitsigns').diffthis()<cr>", "  diff this" },
    ["<localleader>gp"] = { ":lua require('gitsigns').preview_hunk()<cr>", "  preview hunk" },
    ["<localleader>gr"] = { ":Gitsigns reset_hunk<cr>", "  reset hunk" },
    ["<localleader>gs"] = { ":Gitsigns stage_hunk<cr>", "  stage hunk" },
    ["<localleader>gu"] = { ":lua require('gitsigns').undo_stage_hunk()<cr>", "  undo stage buffer" },
    ["<localleader>gx"] = { ":lua require('gitsigns').toggle_deleted()<cr>", "  Toggle Git Deleted signs" },
    ["<localleader>gR"] = { ":lua require('gitsigns').reset_buffer()<cr>", "  reset buffer" },
    ["<localleader>gS"] = { ":lua require('gitsigns').stage_buffer()<cr>", "  stage buffer" },
})
register("v", {
    ["<llocaleader>gr"] = { ":Gitsigns reset_hunk<cr>", "  reset hunk" },
    ["<localleader>gs"] = { ":Gitsigns stage_hunk<cr>", "  stage hunk" },
})
register("o", {
    ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>" },
})
register("x", {
    ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>" },
})
-- <localleader> g - +GitSigns prefix }}}

-- <localleader> T - +Context/NeoTest (in split) prefix {{{
register("n", {

    ["<localleader>T"] = { name = "+NeoTest - in split" },
    ["<localleader>Tf"] = { ":TestFile<cr>", "λ Test file" },
    ["<localleader>Tl"] = { ":TestLast<cr>", "λ Run last test" },
    ["<localleader>Tr"] = { ":TestNearest<cr>", "λ Run tests" },
})
-- <localleader> T - +Context/NeoTest (in split) prefix }}}

-- <localleader> s - +Spelling prefix {{{

register("n", {
    ["<localleader>s"] = { name = "+Spelling" },

    -- spelling
    ["<localleader>ss"] = { "<cmd> Telescope spell_suggest<CR>", "   spelling" },
})
-- <localleader> s - +Spelling prefix }}}

-- <localleader> t - +Context/NeoTest (in background) prefix {{{
register("n", {

    ["<localleader>t"] = { name = "+NeoTest - in background" },
    ["<localleader>ta"] = { ':lua require("neotest").run.attach()<cr>', "λ Attach to tests" },
    ["<localleader>tf"] = { ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "λ Test file" },
    ["<localleader>tl"] = { ':lua require("neotest").run.run_last()<cr>', "λ Run last test" },
    ["<localleader>to"] = { ':lua require("neotest").output.open({ short = true })<cr>', "λ Open output summary" },
    ["<localleader>tr"] = { ':lua require("neotest").run.run()<cr>', "λ Run tests" },
    ["<localleader>ts"] = { ':lua require("neotest").run.stop()<cr>', "λ Stop tests" },
    ["<localleader>tv"] = { ':lua require("neotest").summary.toggle()<cr>', "λ Toggle tests summary" },
    ["<localleader>tO"] = { ':lua require("neotest").output.open()<cr>', "λ Open output window" },
})
-- <localleader> t - +Context/NeoTest (in background) prefix }}}

-- [ and ] custom jumps {{{
register("n", {
    ["[d"] = {
        function()
            vim.diagnostic.goto_prev()
        end,
        "  Diagnostic prev",
    },
    ["d]"] = {
        function()
            vim.diagnostic.goto_next()
        end,
        "  Diagnostic next",
    },
})
-- [ and ] custom jumps }}}
